import 'dart:async';
import 'dart:typed_data';

import 'package:base_project/feature/main/device_model.dart';
import 'package:base_project/feature/main/main_bloc.dart';
import 'package:base_project/product/base/bloc/base_bloc.dart';
import 'package:flutter/material.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';

import '../../product/services/language_services.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late MainBloc mainBloc;
  UsbPort? _port;
  String _status = "Idle";
  List<Widget> _ports = [];
  final List<Widget> _serialData = [];

  StreamSubscription<String>? _subscription;
  Transaction<String>? _transaction;
  UsbDevice? _device;

  Future<bool> _connectTo(device) async {
    _serialData.clear();

    // Ngắt các kết nối cũ nếu có
    await _subscription?.cancel();
    _subscription = null;

    _transaction?.dispose();
    _transaction = null;

    await _port?.close();
    _port = null;

    if (device == null) {
      _device = null;
      _status = "Disconnected";
      mainBloc.addLog(_status);
      return true;
    }

    // Mở cổng mới
    _port = await device.create();
    if (await _port!.open() != true) {
      _status = "Failed to open port";
      mainBloc.addLog(_status);
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

    // Transaction chia chuỗi theo ký tự xuống dòng (LF)
    _transaction = Transaction.stringTerminated(
      _port!.inputStream as Stream<Uint8List>,
      Uint8List.fromList([13, 10]), // \r\n
    );
    await sendCommand("RA1");

    // Lắng nghe dữ liệu
    _subscription = _transaction!.stream.listen((String line) {
      final clean = line.trim();
      if (clean.isEmpty) return;

      mainBloc.addLog(line);
      mainBloc.updateFromMessage(line);

      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(clean),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
    });

    _status = "Connected";
    mainBloc.addLog(_status);
    return true;
  }

  Future<void> sendCommand(String command) async {
    if (_port == null) {
      print("⚠️ Port chưa kết nối");
      return;
    }

    // Append newline giống app Java
    String msg = "$command\r\n";
    Uint8List data = Uint8List.fromList(msg.codeUnits);

    try {
      await _port!.write(data);
      print("Sent: $command");
    } catch (e) {
      print("Error sending: $e");
    }
  }

  void _getPorts() async {
    _ports = [];
    List<UsbDevice> devices = await UsbSerial.listDevices();
    if (!devices.contains(_device)) {
      _connectTo(null);
    }
    print(devices);

    for (var device in devices) {
      _ports.add(
        ListTile(
          leading: Icon(Icons.usb),
          title: Text(device.productName!),
          subtitle: Text(device.manufacturerName!),
          trailing: ElevatedButton(
            child: Text(_device == device ? "Disconnect" : "Connect"),
            onPressed: () {
              _connectTo(_device == device ? null : device).then((res) {
                _getPorts();
              });
            },
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _connectTo(null);
  }

  @override
  void initState() {
    super.initState();
    mainBloc = BlocProvider.of(context);
    UsbSerial.usbEventStream!.listen((UsbEvent event) {
      _getPorts();
    });

    _getPorts();
  }

  @override
  Widget build(BuildContext context) {
    final _logScrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('USB Serial Plugin example app'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            // 🔹 Stream hiển thị trạng thái thiết bị
            StreamBuilder<CompleteDeviceState>(
              stream: mainBloc.streamDeviceState,
              builder: (context, snapshot) {
                final state = snapshot.data ?? CompleteDeviceState();

                Color starColor;
                switch (state.processState) {
                  case ProcessState.running:
                    starColor = Colors.green;
                    break;
                  case ProcessState.finished:
                    starColor = Colors.blue;
                    break;
                  case ProcessState.spraying:
                    starColor = Colors.orange;
                    break;
                  case ProcessState.fillingWater:
                    starColor = Colors.cyan;
                    break;
                  default:
                    starColor = Colors.grey;
                }

                String chemicalStatus;
                switch (state.chemical) {
                  case ChemicalLevel.low:
                    chemicalStatus = "Thấp";
                    break;
                  case ChemicalLevel.empty:
                    chemicalStatus = "Hết";
                    break;
                  default:
                    chemicalStatus = "Đủ";
                }

                String waterStatus;
                switch (state.water) {
                  case WaterLevel.empty:
                    waterStatus = "Hết";
                    break;
                  default:
                    waterStatus = "Đủ";
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: starColor, size: 60),
                    const SizedBox(height: 12),
                    Text("Số lượng cốc: ${state.cupCount}"),
                    Text("Hóa chất: $chemicalStatus"),
                    Text("Nước: $waterStatus"),
                    Text("Updated: ${state.lastUpdated.toIso8601String()}"),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),

            // 🔹 Stream hiển thị logs
            StreamBuilder<List<String>>(
              stream: mainBloc.streamDeviceStateLogs,
              builder: (context, snapshot) {
                final logs = snapshot.data ?? [];

                // auto scroll xuống cuối
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_logScrollController.hasClients) {
                    _logScrollController.jumpTo(
                      _logScrollController.position.maxScrollExtent,
                    );
                  }
                });

                return Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(8),
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Logs:",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.redAccent),
                            onPressed: () => mainBloc.clearLogs(),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white24, height: 1),
                      const SizedBox(height: 6),
                      Expanded(
                        child: ListView.builder(
                          controller: _logScrollController,
                          itemCount: logs.length,
                          itemBuilder: (context, index) {
                            final log = logs[index];
                            return Text(
                              log,
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
