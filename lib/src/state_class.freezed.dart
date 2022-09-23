// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'state_class.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GameState {
  GameClockState get clock => throw _privateConstructorUsedError;
  String get quarter => throw _privateConstructorUsedError;
  int get homeScore => throw _privateConstructorUsedError;
  int get awayScore => throw _privateConstructorUsedError;
  int get homeTimeouts => throw _privateConstructorUsedError;
  int get awayTimeouts => throw _privateConstructorUsedError;
  bool get flagThrown => throw _privateConstructorUsedError;

  /// The text to display for the downs, i.e. `"1ST & 10"`.
  String get downs => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GameStateCopyWith<GameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateCopyWith<$Res> {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) then) =
      _$GameStateCopyWithImpl<$Res>;
  $Res call(
      {GameClockState clock,
      String quarter,
      int homeScore,
      int awayScore,
      int homeTimeouts,
      int awayTimeouts,
      bool flagThrown,
      String downs});
}

/// @nodoc
class _$GameStateCopyWithImpl<$Res> implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._value, this._then);

  final GameState _value;
  // ignore: unused_field
  final $Res Function(GameState) _then;

  @override
  $Res call({
    Object? clock = freezed,
    Object? quarter = freezed,
    Object? homeScore = freezed,
    Object? awayScore = freezed,
    Object? homeTimeouts = freezed,
    Object? awayTimeouts = freezed,
    Object? flagThrown = freezed,
    Object? downs = freezed,
  }) {
    return _then(_value.copyWith(
      clock: clock == freezed
          ? _value.clock
          : clock // ignore: cast_nullable_to_non_nullable
              as GameClockState,
      quarter: quarter == freezed
          ? _value.quarter
          : quarter // ignore: cast_nullable_to_non_nullable
              as String,
      homeScore: homeScore == freezed
          ? _value.homeScore
          : homeScore // ignore: cast_nullable_to_non_nullable
              as int,
      awayScore: awayScore == freezed
          ? _value.awayScore
          : awayScore // ignore: cast_nullable_to_non_nullable
              as int,
      homeTimeouts: homeTimeouts == freezed
          ? _value.homeTimeouts
          : homeTimeouts // ignore: cast_nullable_to_non_nullable
              as int,
      awayTimeouts: awayTimeouts == freezed
          ? _value.awayTimeouts
          : awayTimeouts // ignore: cast_nullable_to_non_nullable
              as int,
      flagThrown: flagThrown == freezed
          ? _value.flagThrown
          : flagThrown // ignore: cast_nullable_to_non_nullable
              as bool,
      downs: downs == freezed
          ? _value.downs
          : downs // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_GameStateCopyWith<$Res> implements $GameStateCopyWith<$Res> {
  factory _$$_GameStateCopyWith(
          _$_GameState value, $Res Function(_$_GameState) then) =
      __$$_GameStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {GameClockState clock,
      String quarter,
      int homeScore,
      int awayScore,
      int homeTimeouts,
      int awayTimeouts,
      bool flagThrown,
      String downs});
}

/// @nodoc
class __$$_GameStateCopyWithImpl<$Res> extends _$GameStateCopyWithImpl<$Res>
    implements _$$_GameStateCopyWith<$Res> {
  __$$_GameStateCopyWithImpl(
      _$_GameState _value, $Res Function(_$_GameState) _then)
      : super(_value, (v) => _then(v as _$_GameState));

  @override
  _$_GameState get _value => super._value as _$_GameState;

  @override
  $Res call({
    Object? clock = freezed,
    Object? quarter = freezed,
    Object? homeScore = freezed,
    Object? awayScore = freezed,
    Object? homeTimeouts = freezed,
    Object? awayTimeouts = freezed,
    Object? flagThrown = freezed,
    Object? downs = freezed,
  }) {
    return _then(_$_GameState(
      clock: clock == freezed
          ? _value.clock
          : clock // ignore: cast_nullable_to_non_nullable
              as GameClockState,
      quarter: quarter == freezed
          ? _value.quarter
          : quarter // ignore: cast_nullable_to_non_nullable
              as String,
      homeScore: homeScore == freezed
          ? _value.homeScore
          : homeScore // ignore: cast_nullable_to_non_nullable
              as int,
      awayScore: awayScore == freezed
          ? _value.awayScore
          : awayScore // ignore: cast_nullable_to_non_nullable
              as int,
      homeTimeouts: homeTimeouts == freezed
          ? _value.homeTimeouts
          : homeTimeouts // ignore: cast_nullable_to_non_nullable
              as int,
      awayTimeouts: awayTimeouts == freezed
          ? _value.awayTimeouts
          : awayTimeouts // ignore: cast_nullable_to_non_nullable
              as int,
      flagThrown: flagThrown == freezed
          ? _value.flagThrown
          : flagThrown // ignore: cast_nullable_to_non_nullable
              as bool,
      downs: downs == freezed
          ? _value.downs
          : downs // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_GameState implements _GameState {
  const _$_GameState(
      {this.clock = const GameClockState(0, 0),
      this.quarter = "1st",
      this.homeScore = 0,
      this.awayScore = 0,
      this.homeTimeouts = 3,
      this.awayTimeouts = 3,
      this.flagThrown = false,
      this.downs = ""});

  @override
  @JsonKey()
  final GameClockState clock;
  @override
  @JsonKey()
  final String quarter;
  @override
  @JsonKey()
  final int homeScore;
  @override
  @JsonKey()
  final int awayScore;
  @override
  @JsonKey()
  final int homeTimeouts;
  @override
  @JsonKey()
  final int awayTimeouts;
  @override
  @JsonKey()
  final bool flagThrown;

  /// The text to display for the downs, i.e. `"1ST & 10"`.
  @override
  @JsonKey()
  final String downs;

  @override
  String toString() {
    return 'GameState(clock: $clock, quarter: $quarter, homeScore: $homeScore, awayScore: $awayScore, homeTimeouts: $homeTimeouts, awayTimeouts: $awayTimeouts, flagThrown: $flagThrown, downs: $downs)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GameState &&
            const DeepCollectionEquality().equals(other.clock, clock) &&
            const DeepCollectionEquality().equals(other.quarter, quarter) &&
            const DeepCollectionEquality().equals(other.homeScore, homeScore) &&
            const DeepCollectionEquality().equals(other.awayScore, awayScore) &&
            const DeepCollectionEquality()
                .equals(other.homeTimeouts, homeTimeouts) &&
            const DeepCollectionEquality()
                .equals(other.awayTimeouts, awayTimeouts) &&
            const DeepCollectionEquality()
                .equals(other.flagThrown, flagThrown) &&
            const DeepCollectionEquality().equals(other.downs, downs));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(clock),
      const DeepCollectionEquality().hash(quarter),
      const DeepCollectionEquality().hash(homeScore),
      const DeepCollectionEquality().hash(awayScore),
      const DeepCollectionEquality().hash(homeTimeouts),
      const DeepCollectionEquality().hash(awayTimeouts),
      const DeepCollectionEquality().hash(flagThrown),
      const DeepCollectionEquality().hash(downs));

  @JsonKey(ignore: true)
  @override
  _$$_GameStateCopyWith<_$_GameState> get copyWith =>
      __$$_GameStateCopyWithImpl<_$_GameState>(this, _$identity);
}

abstract class _GameState implements GameState {
  const factory _GameState(
      {final GameClockState clock,
      final String quarter,
      final int homeScore,
      final int awayScore,
      final int homeTimeouts,
      final int awayTimeouts,
      final bool flagThrown,
      final String downs}) = _$_GameState;

  @override
  GameClockState get clock;
  @override
  String get quarter;
  @override
  int get homeScore;
  @override
  int get awayScore;
  @override
  int get homeTimeouts;
  @override
  int get awayTimeouts;
  @override
  bool get flagThrown;
  @override

  /// The text to display for the downs, i.e. `"1ST & 10"`.
  String get downs;
  @override
  @JsonKey(ignore: true)
  _$$_GameStateCopyWith<_$_GameState> get copyWith =>
      throw _privateConstructorUsedError;
}
