import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final AutoDisposeChangeNotifierProvider<ThemeModeState> themeProvider =
    ChangeNotifierProvider.autoDispose(
        (AutoDisposeChangeNotifierProviderRef<ThemeModeState> ref) {
  return ThemeModeState();
});

class ThemeModeState extends ChangeNotifier {
  ThemeModeState() {
    final String mode = Hive.box('prefs')
        .get('themeMode', defaultValue: ThemeMode.system.toString()) as String;
    switch (mode) {
      case 'ThemeMode.dark':
        themeMode = ThemeMode.dark;
        break;
      case 'ThemeMode.light':
        themeMode = ThemeMode.light;
        break;
      case 'ThemeMode.system':
        themeMode = ThemeMode.system;
        break;
    }
  }

  ThemeMode? themeMode;

  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    Hive.box('prefs').put('themeMode', themeMode.toString());
    notifyListeners();
  }
}
