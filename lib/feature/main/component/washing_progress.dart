import 'dart:developer';

import 'package:base_project/feature/main/device_model.dart';
import 'package:base_project/feature/main/main_bloc.dart';
import 'package:base_project/product/extension/context_extension.dart';
import 'package:base_project/product/shared/shared_transistion.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';

class ProgressData {
  final int percent;
  final String gifUrl;
  final String text;

  const ProgressData({
    required this.percent,
    required this.gifUrl,
    required this.text,
  });
}

washingTeethProgress(
    BuildContext context, MainBloc mainBloc, List<String> logs) {
  log("MainBloc state: ${mainBloc.current}");
  mainBloc.addLog("kjsahdkjsahdas");
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    transitionBuilder: transitionsLeftToRight,
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return ProgressDialogContent(
        mainBloc: mainBloc,
        logs: logs,
      );
    },
  );
}

// Widget riêng cho nội dung progress dialog
class ProgressDialogContent extends StatelessWidget {
  final MainBloc mainBloc;
  final List<String> logs;

  const ProgressDialogContent({
    super.key,
    required this.mainBloc,
    required this.logs,
  });

  @override
  Widget build(BuildContext context) {
    final logScrollController = ScrollController();
    return StreamBuilder<CompleteDeviceState>(
      stream: mainBloc.streamDeviceState,
      builder: (context, snapshot) {
        final state = snapshot.data ?? mainBloc.current;
        final gifUrl = _getGifUrl(state.processState);
        final progressPercent = _getProgressPercent(state.processState);
        final progressText = _getProgressText(state.processState);
        // if (state.lastNotification == NotificationType.se1) {
        //   return const Scaffold(
        //     body: Center(
        //       child: Text(
        //         "Quá trình rửa đã hoàn tất, vui lòng lấy cốc ra!",
        //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        //       ),
        //     ),
        //   );
        // } else if (state.lastNotification == NotificationType.pg2) {
        //   // Pop ngay lập tức và return empty để tránh render
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     Navigator.pop(context);
        //   });
        //   return const SizedBox.shrink();
        // }
        // else{
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Load image chỉ khi URL có nội dung
                if (gifUrl.isNotEmpty)
                  Image.network(
                    gifUrl,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const CircularProgressIndicator(); // Placeholder khi load
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error,
                          size: 200); // Fallback nếu load fail
                    },
                  )
                else
                  const SizedBox(height: 200), // Placeholder rỗng
                Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: LinearPercentIndicator(
                      animation: true,
                      lineHeight: context.highValue,
                      percent: progressPercent / 100,
                      backgroundColor: Colors.grey.shade300,
                      progressColor: Colors.blue,
                      center: Text(
                        "$progressPercent%",
                        style: const TextStyle(color: Colors.white),
                      ),
                      barRadius: const Radius.circular(30),
                    ),
                  ),
                ),
                Text(
                  progressText,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                // Hiển thị logs
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
        );
        // }
      },
    );
  }

  String _getGifUrl(ProcessState processState) {
    switch (processState) {
      case ProcessState.fillingWater:
        return "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExdWhjcWMweHYwOWViMHZiN2hzaTFybWNnNjdlM3owdXAwMnZ5azhrdCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/l2JJMbSXUFUaiKt2w/giphy.gif";
      case ProcessState.spraying:
        return "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExaXlvNm0yOXM5ZXh5cng3MXFiYTNvaTB2ZW45anpmOHY1Y2RqcDc2eiZlcD12MV9naWZzX3NlYXJjaCZjdD1n/eAyQRMB1rTVHXL9HPy/giphy.gif";
      case ProcessState.finished:
        return "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExczJobXhzdnI2MGJjYmsxbThxOTN1ZTVnbGJpaDVzYWEwNjN2OW4wbCZlcD12MV9naWZzX3NlYXJjaCZjdD1n/8utnLQN5OdoR8C0JAN/giphy.gif";
      default:
        return '';
    }
  }

  int _getProgressPercent(ProcessState processState) {
    switch (processState) {
      case ProcessState.fillingWater:
        return 30;
      case ProcessState.spraying:
        return 70;
      case ProcessState.finished:
        return 100;
      default:
        return 0;
    }
  }

  String _getProgressText(ProcessState processState) {
    switch (processState) {
      case ProcessState.fillingWater:
        return "Đang cấp nước vào thiết bị...";
      case ProcessState.spraying:
        return "Đang phun dung dịch rửa...";
      case ProcessState.finished:
        return "Quá trình rửa hoàn tất!";
      default:
        return 'Quá trình xử lý đang diễn ra. Vui lòng chờ...';
    }
  }
}
