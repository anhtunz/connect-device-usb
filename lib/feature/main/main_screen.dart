import 'package:base_project/feature/main/component/washing_progress.dart';
import 'package:base_project/feature/main/component/water_count.dart';
import 'package:base_project/feature/main/device_model.dart';
import 'package:base_project/feature/main/main_bloc.dart';
import 'package:base_project/product/base/bloc/base_bloc.dart';
import 'package:base_project/product/extension/context_extension.dart';
import 'package:base_project/product/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:usb_serial/usb_serial.dart';

import 'component/chemical_card.dart';
import 'component/water_progress_bar.dart';

class MainScreen extends StatefulWidget {
  final UsbDevice? device;

  const MainScreen({super.key, this.device});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

// Định nghĩa các hằng số màu sắc và kích thước để tái sử dụng
const Color primaryBlue = Color(0xFF64B3F0);
const Color secondaryBlue = Color(0xFF5399D4);
const Color lightBlue = Color(0xFFA9DDF8);
const Color textGray = Color(0xFF8698AA);
const Color greenAccent = Colors.lightGreenAccent;

class _MainScreenState extends State<MainScreen> {
  late MainBloc mainBloc;
  final ToastService toastService = ToastService();

  @override
  void dispose() {
    super.dispose();
    mainBloc.connectTo(null);
  }

  @override
  void initState() {
    super.initState();
    mainBloc = BlocProvider.of(context);
    toastService.init(context);
    UsbSerial.usbEventStream!.listen((UsbEvent event) {
      mainBloc.getPorts();
    });
    mainBloc.getPorts();
    // Auto-connect if device is provided via navigation
    if (widget.device != null) {
      mainBloc.connectTo(widget.device);
    }
  }

  @override
  Widget build(BuildContext context) {
    final logScrollController = ScrollController();
    return Scaffold(
      backgroundColor: Color(0xFFE1E9F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: context.paddingMedium,
          child: Column(
            children: <Widget>[
              StreamBuilder<CompleteDeviceState>(
                stream: mainBloc.streamDeviceState,
                builder: (context, snapshot) {
                  final state = snapshot.data ?? CompleteDeviceState();
                  if (state.processState == ProcessState.running) {
                    washingTeethProgress(context, state);
                  }
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: context.dynamicWidth(0.3),
                              child: WaterCount(cupCount: state.cupCount)),
                          SizedBox(
                            width: context.dynamicWidth(0.3),
                            child: WaterProgressBar(
                              progress: state.progress,
                              waterLevel: state.water,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: context.mediumValue,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                              width: context.dynamicWidth(0.3),
                              child: ChemicalStatusCard(
                                  chemicalLevel: state.chemical)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: context.dynamicHeight(0.2),
                                width: context.dynamicWidth(0.3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.transparent,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Center(
                        child: SizedBox(
                          width: context.dynamicWidth(0.33),
                          height: context.dynamicHeight(0.15),
                          child: Material(
                            borderRadius: BorderRadius.circular(50),
                            child: Ink(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF70BDF4),
                                    // Color(0xFF5691C8),
                                    Color(0xFF457FCA),
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () async {
                                  // mainBloc.startWashingTeeth(
                                  //     state, toastService);
                                  washingTeethProgress(
                                      context,
                                      CompleteDeviceState(
                                          processState: ProcessState.running));
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 32),
                                  child: Text(
                                    'Khởi động',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
              SizedBox(height: context.highValue),
              // 🔹 Stream hiển thị logs
              StreamBuilder<List<String>>(
                stream: mainBloc.streamDeviceStateLogs,
                builder: (context, snapshot) {
                  final logs = snapshot.data ?? [];

                  // auto scroll xuống cuối
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (logScrollController.hasClients) {
                      logScrollController.jumpTo(
                        logScrollController.position.maxScrollExtent,
                      );
                    }
                  });

                  return Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(8),
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.8),
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
                            controller: logScrollController,
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
      ),
    );
  }
}
