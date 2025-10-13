import 'dart:developer';

import 'package:base_project/feature/main/device_model.dart';
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

Future<void> washingTeethProgress(
    BuildContext context, CompleteDeviceState state) async {
  log("CompleteDeviceState: $state");

  // Map dữ liệu progress theo ProcessState, dễ mở rộng
  const Map<ProcessState, ProgressData> progressMap = {
    ProcessState.fillingWater: ProgressData(
      percent: 30,
      gifUrl:
          "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExdWhjcWMweHYwOWViMHZiN2hzaTFybWNnNjdlM3owdXAwMnZ5azhrdCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/l2JJMbSXUFUaiKt2w/giphy.gif",
      text: "Đang cấp nước vào thiết bị...",
    ),
    ProcessState.spraying: ProgressData(
      percent: 70,
      gifUrl:
          "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExaXlvNm0yOXM5ZXh5cng3MXFiYTNvaTB2ZW45anpmOHY1Y2RqcDc2eiZlcD12MV9naWZzX3NlYXJjaCZjdD1n/eAyQRMB1rTVHXL9HPy/giphy.gif",
      text: "Đang phun dung dịch rửa...",
    ),
    ProcessState.finished: ProgressData(
      percent: 100,
      gifUrl:
          "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExczJobXhzdnI2MGJjYmsxbThxOTN1ZTVnbGJpaDVzYWEwNjN2OW4wbCZlcD12MV9naWZzX3NlYXJjaCZjdD1n/8utnLQN5OdoR8C0JAN/giphy.gif",
      text: "Quá trình rửa hoàn tất!",
    ),
  };

  // Lấy dữ liệu progress, fallback nếu không khớp
  final ProgressData? progressData = progressMap[state.processState];
  final int progressPercent = progressData?.percent ?? 0;
  final String gifUrl = progressData?.gifUrl ?? '';
  final String progressText =
      progressData?.text ?? 'Quá trình xử lý đang diễn ra. Vui lòng chờ...';

  await showGeneralDialog(
    context: context,
    barrierDismissible: false,
    transitionBuilder: transitionsLeftToRight,
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      if (state.lastNotification == NotificationType.se1) {
        return const Scaffold(
          body: Center(
            child: Text(
              "Quá trình rửa đã hoàn tất, vui lòng lấy cốc ra!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
        );
      } else if (state.lastNotification == NotificationType.pg2) {
        // Pop ngay lập tức và return empty để tránh render
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pop(dialogContext);
        });
        return const SizedBox.shrink();
      } else {
        // Hiển thị progress chính
        return ProgressDialogContent(
          gifUrl: gifUrl,
          progressPercent: progressPercent,
          progressText: progressText,
        );
      }
    },
  );
}

// Widget riêng cho nội dung progress dialog
class ProgressDialogContent extends StatelessWidget {
  final String gifUrl;
  final int progressPercent;
  final String progressText;

  const ProgressDialogContent({
    super.key,
    required this.gifUrl,
    required this.progressPercent,
    required this.progressText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
