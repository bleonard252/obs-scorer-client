import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hive/hive.dart';
import 'package:obs_scorer_client/src/settings.dart';
import 'package:obs_scorer_client/src/settings_cache.dart';
import 'package:obs_scorer_client/views/home.dart';
import 'package:obs_scorer_client/views/login.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:obs_websocket/request.dart';
import 'package:pinelogger/pinelogger.dart';
import 'package:pinelogger_flutter/pinelogger_flutter.dart';

//final logPrinter = StreamPrinter(const PrettyDeveloperPrinter());
final appLogger = Pinelogger("client", severity: Severity.verbose, printer: flutterLogger);

void main() {
  // Loggy.initLoggy(
  //   logPrinter: logPrinter,
  //   logOptions: const LogOptions(LogLevel.all, stackTraceLevel: LogLevel.warning),
  //   hierarchicalLogging: true
  // );
  appLogger.debug("Starting app");
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) Hive.init(Directory(".config/obs_scorer_client/").absolute.path);
  unawaited(Future(() async {
    await Hive.openBox("settings");
    await Settings.init(cacheProvider: HiveSettingsCache("settings"));
    runApp(PineloggerContext(logger: appLogger, child: const ProviderScope(child: MyApp())));
  }));
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

extension SourceVisibility on SceneItems {
  Future<void> setVisible(String sourceName, bool visible, [String? sceneName]) async {
    if (sourceName.isEmpty) {
      throw ArgumentError.value(sourceName, "sourceName", "Cannot be empty");
    }
    final scene = sceneName ?? await obsWebSocket.scenes.getCurrentProgramScene();
    assert(scene.isNotEmpty);
    final sourceId = await getSceneItemId(
      sceneName: scene,
      sourceName: sourceName,
    );
    if (sourceId < 0) {
      if (kDebugMode) {
        print("Source $sourceName not found");
      }
      return;
    }
    await setEnabled(SceneItemEnableStateChanged(
      sceneName: scene,
      sceneItemId: sourceId,
      sceneItemEnabled: visible,
    ));
  }
  Future<bool?> getVisible(String sourceName, [String? sceneName]) async {
    if (sourceName.isEmpty) {
      throw ArgumentError.value(sourceName, "sourceName", "Cannot be empty");
    }
    final scene = sceneName ?? await obsWebSocket.scenes.getCurrentProgramScene();
    final sourceId = await getSceneItemId(
      sceneName: scene,
      sourceName: sourceName,
    );
    final response = await getEnabled(
      sceneName: scene,
      sceneItemId: sourceId,
    );
    return response;
  }
}

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = <dynamic>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}
