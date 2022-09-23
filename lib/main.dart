import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hive/hive.dart';
import 'package:obs_scorer_client/src/settings.dart';
import 'package:obs_scorer_client/src/settings_cache.dart';
import 'package:obs_scorer_client/views/home.dart';
import 'package:obs_scorer_client/views/login.dart';
import 'package:obs_websocket/request.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.init(Directory(".config/obs_scorer_client/").absolute.path);
  await Settings.init(cacheProvider: HiveSettingsCache("settings"));
  await Hive.openBox("settings");
  runApp(const ProviderScope(child: MyApp()));
}

final settingsProvider = Provider<Box>((ref) {
  return Hive.box("settings");
});

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'OBS Scorer Client',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Consumer(builder: (context, ref, child) {
        final box = ref.read(settingsProvider);
        if (box.connection.address == null) {
          return const LoginView();
        } else {
          return const HomeView();
        }
      }),
    );
  }
}

extension InputSettings on Inputs {
  /// Set the text on a text input.
  Future<void> setText(String inputName, String text) async {
    await obsWebSocket.send("SetInputSettings", {
      "inputName": inputName,
      "inputSettings": {
        "text": text,
      }
    });
  }
  Future<String?> getText(String inputName) async {
    final response = await obsWebSocket.send("GetInputSettings", {
      "inputName": inputName,
    });
    return response?.responseData?["inputSettings"]["text"];
  }
}