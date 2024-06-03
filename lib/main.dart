import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saavn/frame/home.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final session = await AudioSession.instance;

  await session.configure(const AudioSessionConfiguration.music());
  await SystemTheme.accentColor.load();
  await windowManager.ensureInitialized();

  await Window.initialize();
  await Window.setEffect(
    effect: WindowEffect.aero,
    color: Colors.black45,
    dark: true,
  );

  WindowOptions windowOptions = const WindowOptions(
    center: true,
    title: "Saavn Music Desktop",
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
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
        useMaterial3: true,
        colorSchemeSeed: SystemTheme.accentColor.accent,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColorLight,
          )),
      themeMode: ThemeMode.dark,
      home: const HomeFrame(),
    );
  }
}
