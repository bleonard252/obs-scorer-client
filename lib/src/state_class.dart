import 'package:freezed_annotation/freezed_annotation.dart';

part 'state_class.freezed.dart';

@freezed
class GameState with _$GameState {
  const factory GameState({
    @Default(GameClockState(0, 0)) GameClockState clock,
    @Default("1st") String quarter,
    @Default(0) int homeScore,
    @Default(0) int awayScore,
    @Default(3) int homeTimeouts,
    @Default(3) int awayTimeouts,
    @Default(false) bool flagThrown,
    /// The text to display for the downs, i.e. `"1ST & 10"`.
    @Default("") String downs,
  }) = _GameState;
}

class GameClockState {
  final int minutes;
  final int seconds;
  const GameClockState(this.minutes, this.seconds);

  const GameClockState.fromSeconds(int seconds)
      : minutes = seconds ~/ 60,
        seconds = seconds % 60;
  @override
  String toString() {
    return "$minutes:${seconds.toString().padLeft(2, "0")}";
  }

  int toSeconds() {
    return (minutes * 60) + seconds;
  }
}

class DownsState {
  /// 1, 2, 3, 4, or 0 if no downs are set.
  final int down;
  /// Number of yards before a first down.
  /// * `-1` for custom downs, i.e. `"1st & Inches"`. This is to prevent
  /// the downs counter from resetting to 1st & 10.
  /// * `-2` for a custom down string, often paired with 0. This replaces
  /// the downs counter with the custom string.
  /// * `0` is considered an **illegal value**.
  final int distance;
  /// i.e. "Inches" or "Goal". This MUST be set when [distance] is `-1`.
  final String? customDistance;

  const DownsState(this.down, this.distance, this.customDistance)
  : assert(distance != 0),
    assert(distance != -1 || customDistance != null), // customDistance must be set when distance is -1
    assert(distance != -2 || customDistance != null), // customDistance must be set when distance is -2
    assert(distance >= -2), // distance must be a positive number or -1 or -2
    assert(down >= 0 && down <= 4);

  DownsState.fromString(String str)
      : down = str.contains("&") ? int.tryParse(str.substring(0, 1)) ?? 1 : 0,
        distance = str.contains("&") ? (int.tryParse(str.substring(5)) ?? -1) : -1,
        customDistance = str.contains("&") ? str.substring(5) : str;

  /// The downs number as an ordinal, i.e. `"1st"`.
  String get ordinalDown {
    // I should probably handle 11th, 12th, and 13th here,
    // but since there are only 4 downs, it's rather pointless.
    switch (down%10) {
      case 1:
        return "${down}st";
      case 2:
        return "${down}nd";
      case 3:
        return "${down}rd";
      default:
        return "${down}th";
    }
  }

  @override
  String toString() {
    if (distance == -1) {
      return "$ordinalDown $customDistance";
    } else if (distance == -2) {
      return customDistance ?? "";
    } else {
      return "$ordinalDown & $distance";
    }
  }
}