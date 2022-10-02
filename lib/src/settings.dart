import 'package:hive/hive.dart';

abstract class ConnectionSetting {
  static const address = "connect.address";
  /// The password to authenticate to OBS with.
  static const password = "connect.password";
}
abstract class SourceSetting {
  /// The name of the source to use for the home score.
  static const homeScore = "source.homeScore";
  /// The name of the source to use for the home logo.
  static const homeLogo = "source.homeLogo";
  /// The name of the source to use for the away score.
  static const awayScore = "source.awayScore";
  /// The name of the source to use for the away logo.
  static const awayLogo = "source.awayLogo";
  /// The prefix for the sources to use for the home timeouts.
  static const homeTimeoutsPrefix = "source.homeTimeoutsPrefix";
  /// The prefix for the sources to use for the away timeouts.
  static const awayTimeoutsPrefix = "source.awayTimeouts";
  /// The name of the source to show when a flag is thrown.
  static const flagThrown = "source.flag";
  /// The name of the source to show when a review is called.
  static const review = "source.review";
  /// The name of the source to use to show the current down and distance.
  static const downs = "source.downs";
  /// The name of the source to hide when no downs are known.
  static const downsContainer = "source.downsContainer";
  /// The name of the source to use to show the current quarter.
  static const quarter = "source.quarter";
  /// The name of the source to use to show the current game clock.
  static const clock = "source.clock";
  static const awayTopText = "source.awayTopText";
  static const awayTopTextContainer = "source.awayTopTextContainer";
  static const homeTopText = "source.homeTopText";
  static const homeTopTextContainer = "source.homeTopTextContainer";
  static const neutralTopText = "source.neutralTopText";
  static const neutralTopTextContainer = "source.neutralTopTextContainer";
}
abstract class SceneSetting {
  static const flagScene = "scene.flag";
  static const reviewScene = "scene.review";
  static const downsScene = "scene.downs";
  static const awayTopTextScene = "scene.awayTopText";
  static const homeTopTextScene = "scene.homeTopText";
  static const neutralTopTextScene = "scene.neutralTopText";
  static const awayTimeouts = "scene.awayTimeouts";
  static const homeTimeouts = "scene.homeTimeouts";
}
abstract class BehaviorSetting {
  /// Whether to hide the downs and distance instead of showing placeholder text.
  /// When `false`, the placeholder text will be shown in the downs and distance
  /// source.
  static const hideDownsWhenNone = "behavior.hideDownsWhenNone";
  /// The placeholder text to show when no downs and distance are known.
  static const textWhenNoDowns = "behavior.textWhenNoDowns";
  /// Whether to uppercase the quarter text (i.e. "1st" -> "1ST").
  static const uppercaseQuarter = "behavior.uppercaseQuarter";
  /// Whether to show an "&" between the down and distance (i.e. "1st & 10").
  /// When `false`, the down and distance will be shown as "1st and 10".
  static const ampersandDowns = "behavior.ampersandDowns";
  /// Whether to uppercase the downs text (i.e. "1st and 10" -> "1ST AND 10").
  static const uppercaseDowns = "behavior.uppercaseDowns";
}

class _connectionSettings {
  final Box _box;
  _connectionSettings(this._box);

  /// The address to connect to OBS with.
  String? get address => _box.getEIN(ConnectionSetting.address);
  set address(String? value) => _box.put(ConnectionSetting.address, value);

  /// The password to authenticate to OBS with.
  String? get password => _box.getEIN(ConnectionSetting.password);
  set password(String? value) => _box.put(ConnectionSetting.password, value);
}

class _sourceSettings {
  final Box _box;
  _sourceSettings(this._box);

  /// The name of the source to use for the home score.
  String? get homeScore => _box.getEIN(SourceSetting.homeScore);

  /// The name of the source to use for the home logo.
  String? get homeLogo => _box.getEIN(SourceSetting.homeLogo);
  set homeLogo(String? value) => _box.put(SourceSetting.homeLogo, value);

  /// The name of the source to use for the away score.
  String? get awayScore => _box.getEIN(SourceSetting.awayScore);
  set awayScore(String? value) => _box.put(SourceSetting.awayScore, value);

  /// The name of the source to use for the away logo.
  String? get awayLogo => _box.getEIN(SourceSetting.awayLogo);
  set awayLogo(String? value) => _box.put(SourceSetting.awayLogo, value);

  /// The prefix for the sources to use for the home timeouts.
  String? get homeTimeoutsPrefix => _box.getEIN(SourceSetting.homeTimeoutsPrefix);
  set homeTimeoutsPrefix(String? value) => _box.put(SourceSetting.homeTimeoutsPrefix, value);

  /// The prefix for the sources to use for the away timeouts.
  String? get awayTimeoutsPrefix => _box.getEIN(SourceSetting.awayTimeoutsPrefix);
  set awayTimeoutsPrefix(String? value) => _box.put(SourceSetting.awayTimeoutsPrefix, value);

  /// The name of the source to show when a flag is thrown.
  String? get flagThrown => _box.getEIN(SourceSetting.flagThrown);
  set flagThrown(String? value) => _box.put(SourceSetting.flagThrown, value);

  /// The name of the source to show when a review is called.
  String? get review => _box.getEIN(SourceSetting.review);
  set review(String? value) => _box.put(SourceSetting.review, value);

  /// The name of the source to use to show the current down and distance.
  String? get downs => _box.getEIN(SourceSetting.downs);
  set downs(String? value) => _box.put(SourceSetting.downs, value);

  /// The name of the source to hide when no downs are known.
  String? get downsContainer => _box.getEIN(SourceSetting.downsContainer);
  set downsContainer(String? value) => _box.put(SourceSetting.downsContainer, value);

  /// The name of the source to use to show the current quarter.
  String? get quarter => _box.getEIN(SourceSetting.quarter);
  set quarter(String? value) => _box.put(SourceSetting.quarter, value);

  /// The name of the source to use to show the current game clock.
  String? get clock => _box.getEIN(SourceSetting.clock);
  set clock(String? value) => _box.put(SourceSetting.clock, value);

  /// The name of the source to use to show the away top text.
  String? get awayTopText => _box.getEIN(SourceSetting.awayTopText);
  set awayTopText(String? value) => _box.put(SourceSetting.awayTopText, value);

  /// The name of the container source to use to show and hide the away top text.
  String? get awayTopTextContainer => _box.getEIN(SourceSetting.awayTopTextContainer);
  set awayTopTextContainer(String? value) => _box.put(SourceSetting.awayTopTextContainer, value);

  /// The name of the source to use to show the home top text.
  String? get homeTopText => _box.getEIN(SourceSetting.homeTopText);
  set homeTopText(String? value) => _box.put(SourceSetting.homeTopText, value);

  /// The name of the container source to use to show and hide the home top text.
  String? get homeTopTextContainer => _box.getEIN(SourceSetting.homeTopTextContainer);
  set homeTopTextContainer(String? value) => _box.put(SourceSetting.homeTopTextContainer, value);

  /// The name of the source to use to show the neutral top text.
  String? get neutralTopText => _box.getEIN(SourceSetting.neutralTopText);
  set neutralTopText(String? value) => _box.put(SourceSetting.neutralTopText, value);

  /// The name of the container source to use to show and hide the neutral top text.
  String? get neutralTopTextContainer => _box.getEIN(SourceSetting.neutralTopTextContainer);
  set neutralTopTextContainer(String? value) => _box.put(SourceSetting.neutralTopTextContainer, value);
}

class _sceneSettings {
  final Box _box;
  _sceneSettings(this._box);

  /// The name of the scene to show when a flag is thrown.
  String? get flagScene => _box.getEIN(SceneSetting.flagScene);
  set flagScene(String? value) => _box.put(SceneSetting.flagScene, value);

  /// The name of the scene to show when a review is called.
  String? get reviewScene => _box.getEIN(SceneSetting.reviewScene);
  set reviewScene(String? value) => _box.put(SceneSetting.reviewScene, value);

  /// The name of the scene to show when downs are known.
  String? get downsScene => _box.getEIN(SceneSetting.downsScene);
  set downsScene(String? value) => _box.put(SceneSetting.downsScene, value);

  /// The name of the scene where the away top text container is.
  String? get awayTopTextScene => _box.getEIN(SceneSetting.awayTopTextScene);
  set awayTopTextScene(String? value) => _box.put(SceneSetting.awayTopTextScene, value);

  /// The name of the scene where the home top text container is.
  String? get homeTopTextScene => _box.getEIN(SceneSetting.homeTopTextScene);
  set homeTopTextScene(String? value) => _box.put(SceneSetting.homeTopTextScene, value);

  /// The name of the scene where the neutral top text container is.
  String? get neutralTopTextScene => _box.getEIN(SceneSetting.neutralTopTextScene);
  set neutralTopTextScene(String? value) => _box.put(SceneSetting.neutralTopTextScene, value);

  String? get homeTimeouts => _box.getEIN(SceneSetting.homeTimeouts);
  set homeTimeouts(String? value) => _box.put(SceneSetting.homeTimeouts, value);

  String? get awayTimeouts => _box.getEIN(SceneSetting.awayTimeouts);
  set awayTimeouts(String? value) => _box.put(SceneSetting.awayTimeouts, value);
}

class _behaviorSettings {
  final Box _box;
  _behaviorSettings(this._box);

  /// Whether to hide the downs and distance instead of showing placeholder text.
  /// When `false`, the placeholder text will be shown in the downs and distance
  /// source.
  bool? get hideDownsWhenNone => _box.getEIN(BehaviorSetting.hideDownsWhenNone);
  set hideDownsWhenNone(bool? value) => _box.put(BehaviorSetting.hideDownsWhenNone, value);

  /// The placeholder text to show when no downs and distance are known.
  String? get textWhenNoDowns => _box.getEIN(BehaviorSetting.textWhenNoDowns);
  set textWhenNoDowns(String? value) => _box.put(BehaviorSetting.textWhenNoDowns, value);

  /// Whether to uppercase the quarter text (i.e. "1st" -> "1ST").
  bool? get uppercaseQuarter => _box.getEIN(BehaviorSetting.uppercaseQuarter);
  set uppercaseQuarter(bool? value) => _box.put(BehaviorSetting.uppercaseQuarter, value);

  /// Whether to show an "&" between the down and distance (i.e. "1st & 10").
  /// When `false`, the down and distance will be shown as "1st and 10".
  bool? get ampersandDowns => _box.getEIN(BehaviorSetting.ampersandDowns);
  set ampersandDowns(bool? value) => _box.put(BehaviorSetting.ampersandDowns, value);

  /// Whether to uppercase the downs text (i.e. "1st and 10" -> "1ST AND 10").
  bool? get uppercaseDowns => _box.getEIN(BehaviorSetting.uppercaseDowns);
  set uppercaseDowns(bool? value) => _box.put(BehaviorSetting.uppercaseDowns, value);
}

extension ExtendedSettings on Box {
  // ignore: library_private_types_in_public_api
  _connectionSettings get connection => _connectionSettings(this);
  // ignore: library_private_types_in_public_api
  _sourceSettings get source => _sourceSettings(this);
  // ignore: library_private_types_in_public_api
  _sceneSettings get scene => _sceneSettings(this);
  // ignore: library_private_types_in_public_api
  _behaviorSettings get behavior => _behaviorSettings(this);

  /// [get] but where empty is null.
  T? getEIN<T>(String key, {T? defaultValue}) {
    final value = get(key);
    if (value == null || value == "" || value == List.empty() || value == Map.identity()) {
      return defaultValue;
    }
    return value;
  }
}
