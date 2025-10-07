import 'dart:async';

import 'package:base_project/feature/main/device_model.dart';
import 'package:flutter/material.dart';

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

  void updateFromMessage(String message) {
    message = message.trim().toUpperCase();

    CompleteDeviceState newState = current.copyWith(
      lastRaw: message,
    );

    switch (message) {
      /// === Quá trình chính ===
      case 'S10':
        newState =
            newState.copyWith(processState: ProcessState.running, cupCount: 0);
        break;
      case 'S11':
        newState =
            newState.copyWith(processState: ProcessState.finished, cupCount: 1);
        break;
      case 'S12':
        newState = newState.copyWith(
            processState: ProcessState.fillingWater, cupCount: 2);
        break;
      case 'S13':
        newState =
            newState.copyWith(processState: ProcessState.spraying, cupCount: 3);
        break;
      case 'S14':
        newState =
            newState.copyWith(processState: ProcessState.idle, cupCount: 4);
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

      default:
        newState =
            newState.copyWith(lastNotification: NotificationType.unknown);
    }

    // Cập nhật trạng thái hiện tại
    current = newState;
    sinkDeviceState.add(newState);
  }

  final _logs = <String>[];

  void addLog(String log) {
    _logs.add(log);
    sinkDeviceStateLogs.add(List.unmodifiable(_logs));
  }

  void clearLogs() {
    _logs.clear();
    sinkDeviceStateLogs.add(List.unmodifiable(_logs));
  }

  @override
  void dispose() {}
}
