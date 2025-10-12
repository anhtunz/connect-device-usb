import 'package:base_project/feature/main/device_model.dart';
import 'package:base_project/product/extension/context_extension.dart';
import 'package:flutter/material.dart';

import '../main_screen.dart';

class WaterProgressBar extends StatelessWidget {
  const WaterProgressBar(
      {super.key, required this.progress, required this.waterLevel});
  final int progress; // Từ 0.0 đến 1.0
  final WaterLevel waterLevel;
  @override
  Widget build(BuildContext context) {
    String waterStatus;
    Color progressColor;
    Color textColor;
    switch (waterLevel) {
      case WaterLevel.empty:
        waterStatus = "Hết";
        progressColor = Colors.red;
        textColor = Colors.red;
        break;
      default:
        waterStatus = "Đủ";
        progressColor = lightBlue;
        textColor = Colors.green;
    }
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: context.dynamicHeight(0.2),
          width: context.dynamicWidth(0.3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: BoxBorder.all(color: Colors.lightBlue[200]!, width: 2),
            color: Colors.transparent,
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                margin: context.paddingMedium,
                width: double.infinity,
                height: 30,
                decoration: BoxDecoration(
                  color: secondaryBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) => Container(
                  margin: context.paddingMedium,
                  width: constraints.maxWidth * (progress / 100),
                  height: 30,
                  decoration: BoxDecoration(
                    color: progressColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: context.lowValue),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mức nước: ",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF8698AA),
              ),
            ),
            Text(
              waterStatus,
              style: TextStyle(
                fontSize: 20,
                color: textColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
