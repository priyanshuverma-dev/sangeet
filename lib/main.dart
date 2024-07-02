import 'package:flutter/material.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

import 'package:sangeet/frame/home.dart';
import 'package:sangeet/initialization.dart';

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
      title: 'Sangeet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.grey,
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.ubuntuTextTheme(ThemeData.dark().textTheme),
        cardTheme: const CardTheme(
          color: Colors.transparent,
          elevation: .01,
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const HomeFrame(),
      builder: BotToastInit(),
      navigatorObservers: [
        BotToastNavigatorObserver(),
      ],
    );
  }
}
