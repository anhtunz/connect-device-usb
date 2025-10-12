import 'dart:developer';

import 'package:base_project/feature/main/device_model.dart';
import 'package:base_project/product/extension/context_extension.dart';
import 'package:base_project/product/shared/shared_transistion.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';

washingTeethProgress(BuildContext context, CompleteDeviceState state) async {
  log("CompleteDeviceState: $state");
  int progressPercent = 0;
  String giffUrl = "";
  String progressText = "";
  if (state.processState == ProcessState.fillingWater) {
    progressPercent = 30;
    giffUrl =
        "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExdWhjcWMweHYwOWViMHZiN2hzaTFybWNnNjdlM3owdXAwMnZ5azhrdCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/l2JJMbSXUFUaiKt2w/giphy.gif";
    progressText = "Đang cấp nước vào thiết bị...";
  } else if (state.processState == ProcessState.spraying) {
    progressPercent = 70;
    giffUrl =
        "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExaXlvNm0yOXM5ZXh5cng3MXFiYTNvaTB2ZW45anpmOHY1Y2RqcDc2eiZlcD12MV9naWZzX3NlYXJjaCZjdD1n/eAyQRMB1rTVHXL9HPy/giphy.gif";
    // giffUrl = "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExYXpxdDhvcWExenhmY3RwdzVzbG9tOHdiMmFwN3Z2Z2hiczhuamhnNCZlcD12MV9naWZzX3NlYXJjaCZjdD1n/gLxFsED6Id9C20MGwN/giphy.gif";
    progressText = "Đang phun dung dịch rửa...";
  } else if (state.processState == ProcessState.finished) {
    progressPercent = 100;
    giffUrl =
        "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExczJobXhzdnI2MGJjYmsxbThxOTN1ZTVnbGJpaDVzYWEwNjN2OW4wbCZlcD12MV9naWZzX3NlYXJjaCZjdD1n/8utnLQN5OdoR8C0JAN/giphy.gif";
    progressText = "Quá trình rửa hoàn tất!";
  }
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    // transitionDuration: context.normalDuration,
    transitionBuilder: transitionsLeftToRight,
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      if (state.lastNotification == NotificationType.se1) {
        return Scaffold(
          body: Center(
            child: Text(
              "Quá trình rửa đã hoàn tất, vui lòng lấy cốc ra!",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
        );
      } else if (state.lastNotification == NotificationType.pg2) {
        Navigator.pop(dialogContext);
        return SizedBox.shrink();
      } else {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.network(
                giffUrl,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
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
                      style: TextStyle(color: Colors.white),
                    ),
                    barRadius: const Radius.circular(30),
                  ),
                ),
              ),
              Text(
                progressText,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      }
    },
  );
}
