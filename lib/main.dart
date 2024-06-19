import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:system_theme/system_theme.dart';

import 'package:saavn/frame/home.dart';
import 'package:saavn/initialization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await hotKeyManager.unregisterAll();
  await initialiseAppFunctions();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saavn Music',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: SystemTheme.accentColor.accent,
      ),
      darkTheme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: Colors.transparent),
      themeMode: ThemeMode.dark,
      home: const HomeFrame(),
      builder: BotToastInit(),
      navigatorObservers: [
        BotToastNavigatorObserver(),
      ],
    );
  }
}
