import 'package:flutter/material.dart';

class IconConstants {
  IconConstants._init();
  static IconConstants? _instance;
  static IconConstants get instance => _instance ??= IconConstants._init();

  String get logo => getIcon("");

  String getIcon(String name) => "assets/icons/$name.png";

  Icon getMaterialIcon(IconData icon) => Icon(icon);
}
