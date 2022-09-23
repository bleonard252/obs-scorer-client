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
  @override
  String toString() {
    return "$minutes:${seconds.toString().padLeft(2, "0")}";
  }
}