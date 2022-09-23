import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hive/hive.dart';
import 'package:obs_scorer_client/src/constants.dart';
import 'package:obs_scorer_client/src/settings_cache.dart';
import 'package:obs_scorer_client/views/home.dart';
import 'package:obs_scorer_client/views/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.init(Directory("~/.config/obs_scorer_client/").absolute.path);
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
        if (box.get(ConnectionSetting.address) == null) {
          return const LoginView();
        } else {
          return const HomeView();
        }
      }),
    );
  }
}
