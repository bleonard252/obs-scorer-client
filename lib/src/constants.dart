abstract class ConnectionSetting {
  /// The address to connect to OBS with.
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
}
abstract class BehaviorSetting {
  static const hideDownsWhenNone = "behavior.hideDownsWhenNone";
  static const textWhenNoDowns = "behavior.textWhenNoDowns";
  static const uppercaseQuarter = "behavior.uppercaseQuarter";
  static const uppercaseDowns = "behavior.uppercaseDowns";
}