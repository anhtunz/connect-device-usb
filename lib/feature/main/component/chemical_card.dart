import 'package:base_project/feature/main/device_model.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../product/extension/context_extension.dart';

class ChemicalStatusCard extends StatelessWidget {
  const ChemicalStatusCard({super.key, required this.chemicalLevel});
  final ChemicalLevel chemicalLevel;

  @override
  Widget build(BuildContext context) {
    String chemicalStatus;
    Color statusColor;
    Color textColor;
    switch (chemicalLevel) {
      case ChemicalLevel.low:
        chemicalStatus = "Thấp";
        statusColor = Color(0xFFEF7722);
        textColor = Color(0xFFEF7722);
        break;
      case ChemicalLevel.empty:
        chemicalStatus = "Hết";
        statusColor = Colors.red;
        textColor = Colors.red;
        break;
      default:
        chemicalStatus = "Đủ";
        statusColor = Color(0xFF56FF14);
        textColor = Color(0xFF64B3F0);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: context.dynamicHeight(0.2),
              // width: context.dynamicWidth(0.2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: BoxBorder.all(color: Colors.lightBlue[200]!, width: 2),
                color: Colors.transparent,
              ),
              child: Center(
                child: Row(
                  children: [
                    SizedBox(
                      width: context.mediumValue,
                    ),
                    Icon(
                      Symbols.experiment_rounded,
                      color: textColor,
                      size: context.dynamicHeight(0.1),
                    ),
                    SizedBox(
                      width: context.mediumValue,
                    ),
                    Text(
                      chemicalStatus,
                      style: TextStyle(
                        fontSize: context.dynamicHeight(0.1),
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(
                      width: context.mediumValue,
                    ),
                    Container(
                      height: context.dynamicHeight(0.05),
                      width: context.dynamicHeight(0.05),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor,
                      ),
                    ),
                    SizedBox(
                      width: context.mediumValue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Text(
          "Lượng hóa chất",
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFF8698AA),
          ),
        ),
        // Icon(Symbols.glass_cup, color: starColor, size: 60),
        // const SizedBox(height: 12),
        // Text("Số lượng cốc: ${state.cupCount}"),
        // Text("Hóa chất: $chemicalStatus"),
        // Text("Nước: $waterStatus"),
        // Text("Updated: ${state.lastUpdated.toIso8601String()}"),
        // const SizedBox(height: 16),
      ],
    );
  }
}
