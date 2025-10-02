import 'dart:async';

import 'package:flutter/material.dart';

import '../../product/base/bloc/base_bloc.dart';

class MainBloc extends BlocBase {

  final language = StreamController<Locale?>.broadcast();
  StreamSink<Locale?> get sinkLanguage => language.sink;
  Stream<Locale?> get streamLanguage => language.stream;

  final theme = StreamController<ThemeData?>.broadcast();
  StreamSink<ThemeData?> get sinkTheme => theme.sink;
  Stream<ThemeData?> get streamTheme => theme.stream;

  final themeMode = StreamController<bool>.broadcast();
  StreamSink<bool> get sinkThemeMode => themeMode.sink;
  Stream<bool> get streamThemeMode => themeMode.stream;

  final isVNIcon = StreamController<bool>.broadcast();
  StreamSink<bool> get sinkIsVNIcon => isVNIcon.sink;
  Stream<bool> get streamIsVNIcon => isVNIcon.stream;

  @override
  void dispose() {}

}
