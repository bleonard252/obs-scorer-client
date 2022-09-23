import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obs_scorer_client/main.dart';
import 'package:obs_scorer_client/src/settings.dart';
import 'package:obs_scorer_client/src/state_class.dart';
import 'package:obs_scorer_client/views/settings.dart';
import 'package:obs_scorer_client/views/widgets/scores.dart';
import 'package:obs_scorer_client/views/widgets/summary.dart';
import 'package:obs_websocket/obs_websocket.dart';

final socketProvider = FutureProvider<ObsWebSocket>((ref) async {
  final box = ref.watch(settingsProvider);
  final socket = await ObsWebSocket.connect("ws://${box.connection.address ?? "localhost:4455"}", password: box.connection.password);
  ref.onDispose(() {
    socket.close();
  });
  // hoping I don't need to say this because it isn't mentioned anywhere
  // await socket.init();
  // await socket.authenticate();
  return socket;
});

final gameStateProvider = StateProvider<GameState>((ref) {
  final box = ref.watch(settingsProvider);
  final sock = ref.watch(socketProvider).value;
  Future(() async {
    late final GameState gameState;
    try {
      gameState = ref.controller.state;
    } catch (e) {
      gameState = const GameState();
    }
    int? awayScore;
    int? homeScore;
    String? downs;
    String? quarter;
    GameClockState? clock;
    try {
      awayScore = box.source.awayScore?.isNotEmpty == true ? await sock?.inputs.getText(box.source.awayScore ?? "").then((value) => int.tryParse(value ?? "")) : null;
      homeScore = box.source.homeScore?.isNotEmpty == true ? await sock?.inputs.getText(box.source.homeScore ?? "").then((value) => int.tryParse(value ?? "")) : null;
      downs = box.source.downs?.isNotEmpty == true ? await sock?.inputs.getText(box.source.downs ?? "") : null;
      quarter = box.source.quarter?.isNotEmpty == true ? await sock?.inputs.getText(box.source.quarter ?? "") : null;
      final clockString = box.source.clock?.isNotEmpty == true ? await sock?.inputs.getText(box.source.clock ?? "") : null;
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
    ref.controller.state = ref.controller.state.copyWith(
      clock: clock ?? gameState.clock,
      awayScore: awayScore ?? gameState.awayScore,
      homeScore: homeScore ?? gameState.homeScore,
      downs: downs ?? gameState.downs,
      quarter: quarter ?? gameState.quarter,
    );
  });
  try {
    return ref.controller.state;
  } catch (e) {
    return const GameState();
  }
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
          Tooltip(
            message: "Settings",
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsView()));
              }
            ),
          )
        ],
      ),
      body: Column(
        children: [
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
        ],
      ),
    );
  }
}