// models/device_state.dart
import 'package:equatable/equatable.dart';

enum ChemicalLevel { ok, low, empty } // S23, S21, S20

enum WaterLevel { ok, empty } // S23, S22

enum ProcessState { idle, running, fillingWater, spraying, finished }

enum NotificationType { pg1, se1, pg2, unknown }

class CompleteDeviceState extends Equatable {
  final ProcessState processState;
  final int progress; // 0..100
  final int cupCount; // 0..4
  final ChemicalLevel chemical;
  final WaterLevel water;
  final NotificationType lastNotification;
  final DateTime lastUpdated;
  final String lastRaw; // raw last message

  CompleteDeviceState({
    this.processState = ProcessState.idle,
    this.progress = 80,
    this.cupCount = 0,
    this.chemical = ChemicalLevel.ok,
    this.water = WaterLevel.ok,
    this.lastNotification = NotificationType.unknown,
    DateTime? lastUpdated,
    this.lastRaw = '',
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  CompleteDeviceState copyWith({
    ProcessState? processState,
    int? progress,
    int? cupCount,
    ChemicalLevel? chemical,
    WaterLevel? water,
    NotificationType? lastNotification,
    DateTime? lastUpdated,
    String? lastRaw,
  }) {
    return CompleteDeviceState(
      processState: processState ?? this.processState,
      progress: progress ?? this.progress,
      cupCount: cupCount ?? this.cupCount,
      chemical: chemical ?? this.chemical,
      water: water ?? this.water,
      lastNotification: lastNotification ?? this.lastNotification,
      lastUpdated: lastUpdated ?? DateTime.now(),
      lastRaw: lastRaw ?? this.lastRaw,
    );
  }

  @override
  List<Object?> get props => [
        processState,
        progress,
        cupCount,
        chemical,
        water,
        lastNotification,
        lastRaw,
      ];
}
