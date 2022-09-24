import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:obs_scorer_client/main.dart';
import 'package:obs_scorer_client/src/settings.dart';
import 'package:obs_scorer_client/src/state_class.dart';
import 'package:obs_scorer_client/views/settings.dart';
import 'package:obs_scorer_client/views/widgets/clock.dart';
import 'package:obs_scorer_client/views/widgets/scores.dart';
import 'package:obs_scorer_client/views/widgets/summary.dart';
import 'package:obs_websocket/obs_websocket.dart';

final socketProvider = FutureProvider<ObsWebSocket>((ref) async {
  final box = ref.watch(settingsProvider);
  final socket = await ObsWebSocket.connect("ws://${box.connection.address ?? "localhost:4455"}", password: box.connection.password);
  ref.onDispose(() {
    socket.close();
  });
  return socket;
});

final gameStateLogger = Loggy("gameStateProvider");
final _gameStateProvider = StreamProvider<GameState>((ref) async* {
  //yield const GameState(awayScore: 42);
  final box = ref.watch(settingsProvider);
  ObsWebSocket? sock = ref.watch(socketProvider).value;
  if (sock == null) {
    if (kDebugMode) {
      gameStateLogger.warning("Socket is null, stopping stream");
    }
    return;
  }
  int? awayScore;
  int? homeScore;
  String? downs;
  String? quarter;
  GameClockState? clock;
  try {
    awayScore = box.source.awayScore?.isNotEmpty == true ? await sock.inputs.getText(box.source.awayScore ?? "").then((value) => int.parse(value ?? "-1")).catchError((e) => 88) : null;
    homeScore = box.source.homeScore?.isNotEmpty == true ? await sock.inputs.getText(box.source.homeScore ?? "").then((value) => int.parse(value ?? "-1")).catchError((e) => 0) : null;
    downs = box.source.downs?.isNotEmpty == true ? await sock.inputs.getText(box.source.downs ?? "--").catchError((e) => "") : null;
    quarter = box.source.quarter?.isNotEmpty == true ? await sock.inputs.getText(box.source.quarter ?? "--").catchError((e) => "") : null;
    final clockString = box.source.clock?.isNotEmpty == true ? await sock.inputs.getText(box.source.clock ?? "-1:-1").catchError((e) => "") : null;
    if (clockString != null) {
      final split = clockString.split(":");
      if (split.length == 2) {
        clock = GameClockState(int.tryParse(split[0]) ?? 0, int.tryParse(split[1]) ?? 0);
      }
    }
  } catch(e) {
    if (kDebugMode) {
      print(e);
    }
    return;
  }
  GameState state = GameState();
  // yield GameState(
  //   clock: clock ?? defaults.clock,
  //   awayScore: awayScore ?? defaults.awayScore,
  //   homeScore: homeScore ?? defaults.homeScore,
  //   downs: downs ?? defaults.downs,
  //   quarter: quarter ?? defaults.quarter,
  // );
  if (awayScore != null) state = state.copyWith(awayScore: awayScore);
  if (homeScore != null) state = state.copyWith(homeScore: homeScore);
  if (downs != null) state = state.copyWith(downs: downs);
  if (quarter != null) state = state.copyWith(quarter: quarter);
  if (clock != null) state = state.copyWith(clock: clock);
  yield state;
  return;
});

refreshGameState(ref) => ref.refresh(_gameStateProvider);

var _lastGameState = const GameState(clock: GameClockState(43, 21));

final gameStateProvider = Provider<GameState>((ref) {
  return ref.watch(_gameStateProvider).map<GameState>(
    data: (data) {
      _lastGameState = data.value;
      return data.value;
    },
    error: (e) {
      gameStateLogger.error("Error in game state", e.error);
      return const GameState();
    },
    loading: (_) => _lastGameState,
  );
});

class HomeView extends ConsumerWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("OBS Scorer Client"),
        actions: [
          // refresh button with tooltip
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Refresh",
            onPressed: () {
              ref.refresh(_gameStateProvider);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: "Settings",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsView()));
            }
          ),
        ],
      ),
      body: Column(
        children: [
          Consumer(builder: ((context, ref, child) {
            ref.listen(socketProvider, (previous, next) {
              next.maybeWhen(
                orElse: () {},
                error: (error, stackTrace) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(error.toString()),
                    duration: const Duration(seconds: 60),
                    action: SnackBarAction(
                      label: "Reconnect",
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ref.refresh(socketProvider);
                      },
                    ),
                  ));
                }
              );
            });

            return Container();
          })),
          const Center(child: Padding(padding: EdgeInsets.all(16.0), child: GameStateSummaryWidget())),
          Wrap(
            children: [
              ScoreEditorCard(
                title: "Away Score",
                score: gameState.awayScore,
                setting: SourceSetting.awayScore,
              ),
              ScoreEditorCard(
                title: "Home Score",
                score: gameState.homeScore,
                setting: SourceSetting.homeScore,
              ),
            ],
          ),
          // Wrap(
          //   children: [
          //     ScoreEditorCard(
          //       title: "Away Score",
          //       score: gameState.awayScore,
          //       setting: SourceSetting.awayScore,
          //     ),
          //     ScoreEditorCard(
          //       title: "Home Score",
          //       score: gameState.homeScore,
          //       setting: SourceSetting.homeScore,
          //     ),
          //   ],
          // ),
          ClockEditorCard(clock: gameState.clock, quarter: gameState.quarter),
        ],
      ),
    );
  }
}