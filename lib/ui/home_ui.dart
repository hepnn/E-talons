import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/theme_mode_state.dart';
import 'history_ui.dart';
import 'scan_ui.dart';

class HomeUi extends StatefulWidget {
  const HomeUi({super.key});

  @override
  State<HomeUi> createState() => _HomeUiState();
}

class _HomeUiState extends State<HomeUi> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            actions: const [
              ThemeIcon(),
              LanguageIcon(),
            ],
            bottom: const TabBar(tabs: [
              Tab(text: 'Scan'),
              Tab(text: 'History'),
            ]),
          ),
          body: const TabBarView(
            children: [
              ScanView(),
              HistoryUI(),
            ],
          )),
    );
  }
}

class ThemeIcon extends ConsumerWidget {
  const ThemeIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeModeState state = ref.watch(themeProvider);

    final IconData icon = state.themeMode == ThemeMode.light
        ? Icons.wb_sunny
        : Icons.nightlight_round;

    return TextButton(
      onPressed: () {
        final newMode = state.themeMode == ThemeMode.light
            ? ThemeMode.dark
            : ThemeMode.light;
        ref.watch(themeProvider.notifier).setThemeMode(newMode);
      },
      child: Icon(
        icon,
        color: state.themeMode == ThemeMode.light
            ? const Color(0xFFf4B427)
            : Colors.white,
      ),
    );
  }
}

class LanguageIcon extends ConsumerWidget {
  const LanguageIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
        onPressed: () {},
        child: const Text('EN', style: TextStyle(fontWeight: FontWeight.bold)));
  }
}
