// toast_service.dart
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastService {
  static final ToastService _instance = ToastService._internal();
  factory ToastService() => _instance;
  ToastService._internal();

  late FToast _fToast;

  void init(BuildContext context) {
    _fToast = FToast();
    _fToast.init(context);
  }

  void show({
    required String message,
    Color backgroundColor = Colors.black87,
    IconData? icon,
    ToastGravity gravity = ToastGravity.CENTER,
    Duration duration = const Duration(seconds: 2),
  }) {
    final toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: backgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, color: Colors.white),
          if (icon != null) const SizedBox(width: 12.0),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
              softWrap: true,
            ),
          ),
        ],
      ),
    );

    _fToast.showToast(
      child: toast,
      gravity: gravity,
      toastDuration: duration,
    );
  }

  void showSuccess(String message) {
    show(
      message: message,
      backgroundColor: Colors.green,
      icon: Icons.check,
    );
  }

  void showError(String message) {
    show(
      message: message,
      backgroundColor: Colors.redAccent,
      icon: Icons.warning,
    );
  }

  void showWithCloseButton(String message) {
    final toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
              softWrap: true,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => _fToast.removeCustomToast(),
          )
        ],
      ),
    );

    _fToast.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: const Duration(seconds: 30),
    );
  }

  void removeToast() {
    _fToast.removeCustomToast();
  }

  void clearAll() {
    _fToast.removeQueuedCustomToasts();
  }
}
