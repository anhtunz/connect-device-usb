import 'dart:async';
import 'dart:typed_data';

import 'package:base_project/feature/main/device_model.dart';
import 'package:base_project/product/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';

import '../../product/base/bloc/base_bloc.dart';

class MainBloc extends BlocBase {
  final language = StreamController<Locale?>.broadcast();
  StreamSink<Locale?> get sinkLanguage => language.sink;
  Stream<Locale?> get streamLanguage => language.stream;

  final theme = StreamController<ThemeData?>.broadcast();
  StreamSink<ThemeData?> get sinkTheme => theme.sink;
  Stream<ThemeData?> get streamTheme => theme.stream;

  final themeMode = StreamController<bool>.broadcast();
  StreamSink<bool> get sinkThemeMode => themeMode.sink;
  Stream<bool> get streamThemeMode => themeMode.stream;

  final isVNIcon = StreamController<bool>.broadcast();
  StreamSink<bool> get sinkIsVNIcon => isVNIcon.sink;
  Stream<bool> get streamIsVNIcon => isVNIcon.stream;

  final line = StreamController<String>.broadcast();
  StreamSink<String> get sinkLine => line.sink;
  Stream<String> get streamLine => line.stream;

  final deviceState = StreamController<CompleteDeviceState>.broadcast();
  StreamSink<CompleteDeviceState> get sinkDeviceState => deviceState.sink;
  Stream<CompleteDeviceState> get streamDeviceState => deviceState.stream;

  final deviceStateLogs = StreamController<List<String>>.broadcast();
  StreamSink<List<String>> get sinkDeviceStateLogs => deviceStateLogs.sink;
  Stream<List<String>> get streamDeviceStateLogs => deviceStateLogs.stream;

  CompleteDeviceState current = CompleteDeviceState();
  bool _isDisposed = false;

  // ==== USB state and helpers ====
  UsbPort? _port;
  UsbDevice? _device;
  Transaction<String>? _transaction;
  StreamSubscription<String>? _subscription;
  String _status = 'Idle';

  // Optional: expose available devices when needed
  final _devicesCtrl = StreamController<List<UsbDevice>>.broadcast();
  Stream<List<UsbDevice>> get devicesStream => _devicesCtrl.stream;

  Future<bool> connectTo(UsbDevice? device) async {
    // stop previous listeners
    await _subscription?.cancel();
    _subscription = null;

    _transaction?.dispose();
    _transaction = null;

    await _port?.close();
    _port = null;

    if (device == null) {
      _device = null;
      _status = 'Disconnected';
      addLog(_status);
      return true;
    }

    // Open new port
    _port = await device.create();
    if (await _port!.open() != true) {
      _status = 'Failed to open port';
      addLog(_status);
      return false;
    }

    _device = device;

    await _port!.setDTR(true);
    await _port!.setRTS(true);
    await _port!.setPortParameters(
      9600,
      UsbPort.DATABITS_8,
      UsbPort.STOPBITS_1,
      UsbPort.PARITY_NONE,
    );

    // setup transaction and initial wake command
    _transaction = Transaction.stringTerminated(
      _port!.inputStream as Stream<Uint8List>,
      Uint8List.fromList([13, 10]), // \r\n
    );
    await sendCommand('RA1');

    _subscription = _transaction!.stream.listen((String line) {
      final clean = line.trim();
      if (clean.isEmpty) return;
      addLog(line);
      updateFromMessage(line);
    });

    _status = 'Connected';
    addLog(_status);
    return true;
  }

  Future<void> sendCommand(String command) async {
    if (_port == null) {
      addLog('WARN: Port not connected');
      return;
    }
    final msg = '$command\r\n';
    final data = Uint8List.fromList(msg.codeUnits);
    try {
      await _port!.write(data);
      addLog('Sent: $command');
    } catch (e) {
      addLog('Error sending: $e');
    }
  }

  Future<List<UsbDevice>> getPorts() async {
    final devices = await UsbSerial.listDevices();
    // auto disconnect if current device missing
    if (!devices.contains(_device)) {
      await connectTo(null);
    }
    _devicesCtrl.add(devices);
    return devices;
  }

  void updateFromMessage(String message) {
    message = message.trim().toUpperCase();

    CompleteDeviceState newState = current.copyWith(
      lastRaw: message,
    );

    switch (message) {
      /// === Quá trình chính ===
      case 'S10':
        newState = newState.copyWith(cupCount: 0);
        break;
      case 'S11':
        newState = newState.copyWith(cupCount: 1);
        break;
      case 'S12':
        newState = newState.copyWith(cupCount: 2);
        break;
      case 'S13':
        newState = newState.copyWith(cupCount: 3);
        break;
      case 'S14':
        newState = newState.copyWith(cupCount: 4);
        break;

      /// === Mức hóa chất ===
      case 'S20':
        newState = newState.copyWith(chemical: ChemicalLevel.empty);
        break;
      case 'S21':
        newState = newState.copyWith(chemical: ChemicalLevel.low);
        break;
      case 'S23':
        newState = newState.copyWith(chemical: ChemicalLevel.ok);
        break;

      /// === Mức nước ===
      case 'S22':
        newState = newState.copyWith(water: WaterLevel.empty);
        break;

      /// === Thông báo ===
      case 'PG1':
        newState = newState.copyWith(lastNotification: NotificationType.pg1);
        break;
      case 'PG2':
        newState = newState.copyWith(lastNotification: NotificationType.pg2);
        break;
      case 'SE1':
        newState = newState.copyWith(lastNotification: NotificationType.se1);
        break;
      case "RE1":
        newState = newState.copyWith(processState: ProcessState.idle);
        break;
      case "ST1":
        newState = newState.copyWith(processState: ProcessState.running);
        break;
      case "RU1":
        newState = newState.copyWith(processState: ProcessState.fillingWater);
        break;
      case "RU3":
        newState = newState.copyWith(processState: ProcessState.spraying);
        break;
      case "RU4":
        newState = newState.copyWith(processState: ProcessState.finished);
        break;

      default:
        newState =
            newState.copyWith(lastNotification: NotificationType.unknown);
    }

    // Cập nhật trạng thái hiện tại
    current = newState;
    if (_isDisposed || deviceState.isClosed) return;
    sinkDeviceState.add(newState);
  }

  void startWashingTeeth(
      CompleteDeviceState state, ToastService toastService) async {
    toastService.removeToast();
    if (state.processState == ProcessState.running ||
        state.processState == ProcessState.fillingWater ||
        state.processState == ProcessState.spraying) {
      toastService.showError("Quá trình rửa đang diễn ra");
      return;
    }
    if (state.cupCount == 0) {
      toastService.showError("Chưa có cốc, vui lòng đặt cốc vào");
      return;
    }
    if (state.chemical == ChemicalLevel.empty) {
      toastService.showError("Hóa chất đã hết, vui lòng nạp thêm");
      return;
    }
    if (state.water == WaterLevel.empty) {
      toastService.showError("Nước đã hết, vui lòng nạp thêm");
      return;
    }
    await sendCommand('RE1');
  }

  final _logs = <String>[];

  void addLog(String log) {
    if (_isDisposed || deviceStateLogs.isClosed) return;
    _logs.add(log);
    try {
      sinkDeviceStateLogs.add(List.unmodifiable(_logs));
    } catch (_) {
      // no-op if already closed
    }
  }

  void clearLogs() {
    if (_isDisposed || deviceStateLogs.isClosed) return;
    _logs.clear();
    try {
      sinkDeviceStateLogs.add(List.unmodifiable(_logs));
    } catch (_) {
      // no-op if already closed
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    // close usb
    _subscription?.cancel();
    _transaction?.dispose();
    _port?.close();

    // close streams
    language.close();
    theme.close();
    themeMode.close();
    isVNIcon.close();
    line.close();
    deviceState.close();
    deviceStateLogs.close();
    _devicesCtrl.close();
  }
}
