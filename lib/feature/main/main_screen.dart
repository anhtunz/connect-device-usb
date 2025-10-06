import 'dart:async';
import 'dart:typed_data';

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

  final TextEditingController _textController = TextEditingController();

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
      setState(() => _status = "Disconnected");
      return true;
    }

    // Mở cổng mới
    _port = await device.create();
    if (await _port!.open() != true) {
      setState(() => _status = "Failed to open port");
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

    // Lắng nghe dữ liệu
    _subscription = _transaction!.stream.listen((String line) {
      final clean = line.trim();
      if (clean.isEmpty) return;

      print("📩 Nhận: $clean");
      mainBloc.sinkLine.add(clean);

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

    setState(() => _status = "Connected");
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
      _ports.add(ListTile(
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
          )));
    }

    setState(() {
      print(_ports);
    });
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

  Color getStarColor(String? line) {
    switch (line?.trim()) {
      case "S10":
        return Colors.green;
      case "S11":
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('USB Serial Plugin example app'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            StreamBuilder<String>(
              stream: mainBloc.streamLine,
              builder: (context, snapshot) {
                final line = snapshot.data?.trim() ?? ""; // bỏ \r\n nếu có
                return Icon(
                  Icons.star,
                  color: getStarColor(line),
                );
              },
            ),
            TextButton(
              onPressed: () async {
                await sendCommand("RA1");
              },
              child: Text("show SnackBar"),
            ),
            Text(
                _ports.isNotEmpty
                    ? "Available Serial Ports"
                    : "No serial devices available",
                style: Theme.of(context).textTheme.titleLarge),
            ..._ports,
            Text('Status: $_status\n'),
            Text('info: ${_port.toString()}\n'),
            ListTile(
              title: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Text To Send',
                ),
              ),
              trailing: ElevatedButton(
                onPressed: () async {
                  String text = _textController.text;
                  await sendCommand(text);
                },
                child: Text("Send"),
              ),
            ),
            Text("Result Data", style: Theme.of(context).textTheme.titleLarge),
            ..._serialData,
          ],
        ),
      ),
    );
  }
}
