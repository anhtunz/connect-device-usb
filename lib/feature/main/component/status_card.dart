import 'package:flutter/material.dart';

import '../../../product/extension/context_extension.dart';
import '../main_screen.dart';

class StatusCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Widget? progressBar;

  const StatusCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.progressBar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: context.dynamicHeight(0.2),
          width: context.dynamicWidth(0.3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.lightBlue[200]!, width: 2),
            color: Colors.transparent,
          ),
          child: progressBar ?? _buildIconContent(icon, context),
        ),
        SizedBox(height: context.lowValue),
        Text(
          title,
          style: const TextStyle(fontSize: 20, color: textGray),
        ),
      ],
    );
  }

  Widget _buildIconContent(IconData iconData, BuildContext context) {
    return Center(
      child: Icon(
        iconData,
        size: context.dynamicHeight(0.1),
        color: primaryBlue,
      ),
    );
  }
}
