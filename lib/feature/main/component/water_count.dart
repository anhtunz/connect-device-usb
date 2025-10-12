import 'package:base_project/product/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class WaterCount extends StatefulWidget {
  const WaterCount({super.key, required this.cupCount});
  final int cupCount;
  @override
  State<WaterCount> createState() => _WaterCountState();
}

class _WaterCountState extends State<WaterCount> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: context.dynamicHeight(0.2),
              width: context.dynamicWidth(0.1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: BoxBorder.all(color: Colors.lightBlue[200]!, width: 2),
                color: Colors.transparent,
              ),
              child: Center(
                child: Icon(
                  Symbols.coffee,
                  fill: 1,
                  size: context.dynamicHeight(0.1),
                  color: Color(0xFF64B3F0),
                  // widget.cupCount > 0
                  //     ? const Color(0xFF64B3F0)
                  //     : const Color.fromARGB(255, 235, 71, 71),
                ),
              ),
            ),
            SizedBox(
              width: context.mediumValue,
            ),
            Text(
              widget.cupCount.toString(),
              style: TextStyle(
                fontSize: context.dynamicHeight(0.15),
                fontWeight: FontWeight.bold,
                color: widget.cupCount > 0
                    ? const Color(0xFF64B3F0)
                    : const Color.fromARGB(255, 235, 71, 71),
              ),
            ),
          ],
        ),
        Text(
          "Số lượng cốc hiện tại",
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
