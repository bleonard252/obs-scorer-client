import 'package:hive/hive.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:slugify/slugify.dart';

/// Push settings to OBS.
Future<void> pushSettings(Box box, ObsWebSocket obs) async {
  final sceneCollection = await obs.config.getSceneCollectionList().then((value) => value.currentSceneCollectionName);
  await obs.config.setPersistentData(
    realm: "OBS_WEBSOCKET_DATA_REALM_PROFILE",
    slotName: "OBS_SCORER_CLIENT_PRESET_${slugify(sceneCollection, delimiter: '_').toUpperCase()}",
    slotValue: box.toMap()
    ..removeWhere((key, value) => key is String && key.startsWith("connection.")) // remove connection settings
  );
}

/// Pull settings from OBS.
Future<void> pullSettings(Box box, ObsWebSocket obs) async {
  final sceneCollection = await obs.config.getSceneCollectionList().then((value) => value.currentSceneCollectionName);
  late final dynamic settings;
  try {
    settings = await obs.config.getPersistentData(
      realm: "OBS_WEBSOCKET_DATA_REALM_PROFILE",
      slotName: "OBS_SCORER_CLIENT_PRESET_${slugify(sceneCollection, delimiter: '_').toUpperCase()}"
    ).then((value) => value["slotValue"]);
  } catch(e) {
    late final String profile;
    try {
      profile = await obs.config.getProfileList().then((value) => value.currentProfileName);
    } catch(e) {
      throw Exception("Could not get current profile. OBS connection probably failed");
    }
    throw Exception("No settings found in profile '$profile' for scene collection '$sceneCollection'.");
  }
  await box.putAll(settings);
}