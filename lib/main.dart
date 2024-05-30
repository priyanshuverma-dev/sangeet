import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savaan/functions/explore/views/explore_view.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemTheme.accentColor.load();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    title: "Savaan Music Desktop",
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Savaan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: SystemTheme.accentColor.accent,
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: SystemTheme.accentColor.darkest,
      ),
      themeMode: ThemeMode.dark,
      home: const ExploreView(),
    );
  }
}
