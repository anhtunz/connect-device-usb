import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:usb_serial/usb_serial.dart';

import '../../product/constants/navigation/navigation_constants.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  UsbDevice? _selectedDevice;
  UsbPort? _port;
  String _status = 'Đang tìm thiết bị...';
  StreamSubscription<UsbEvent>? _usbEvents;

  @override
  void initState() {
    super.initState();
    _listenUsbEvents();
    _scanDevices();
  }

  void _listenUsbEvents() {
    _usbEvents = UsbSerial.usbEventStream?.listen((event) {
      _scanDevices();
    });
  }

  Future<void> _scanDevices() async {
    final devices = await UsbSerial.listDevices();
    if (devices.isEmpty) {
      setState(() {
        _selectedDevice = null;
        _status = 'Không tìm thấy thiết bị USB';
      });
      return;
    }

    setState(() {
      _selectedDevice = devices.first; // chọn thiết bị đầu tiên
      _status = 'Đã tìm thấy ${_selectedDevice?.productName ?? 'USB'}';
    });
    // Tự động kết nối với thiết bị đầu tiên
    await _connectTo(_selectedDevice);
  }

  Future<bool> _connectTo(UsbDevice? device) async {
    await _port?.close();
    _port = null;

    if (device == null) {
      setState(() => _status = 'Chưa kết nối');
      return false;
    }

    final port = await device.create();
    if (port == null || await port.open() != true) {
      setState(() => _status = 'Không mở được cổng');
      return false;
    }
    _port = port;

    await port.setDTR(true);
    await port.setRTS(true);
    await port.setPortParameters(
      9600,
      UsbPort.DATABITS_8,
      UsbPort.STOPBITS_1,
      UsbPort.PARITY_NONE,
    );

    setState(() => _status = 'Đã kết nối');
    return true;
  }

  Future<void> _sendRA1() async {
    if (_port == null) return;
    final msg = 'RA1\r\n';
    await _port!.write(Uint8List.fromList(msg.codeUnits));
  }

  @override
  void dispose() {
    _usbEvents?.cancel();
    _port?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chào mừng')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trạng thái: $_status',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (_selectedDevice != null)
              ListTile(
                leading: const Icon(Icons.usb),
                title: Text(_selectedDevice!.productName ?? 'USB Device'),
                subtitle:
                    Text(_selectedDevice!.manufacturerName ?? 'Manufacturer'),
                trailing: const Icon(Icons.check_circle, color: Colors.green),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedDevice == null
                    ? null
                    : () async {
                        final ok = await _connectTo(_selectedDevice);
                        if (!ok) return;
                        await _sendRA1();
                        // Close here to avoid double-open; MainScreen will reconnect
                        await _port?.close();
                        _port = null;
                        if (!mounted) return;
                        // Navigate to MainScreen and pass device via extra
                        context.go(
                          NavigationConstants.HOME_PATH,
                          extra: _selectedDevice,
                        );
                      },
                child: const Text('Kết nối'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
