import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obs_scorer_client/main.dart';
import 'package:obs_scorer_client/src/constants.dart';
import 'package:obs_scorer_client/src/state_class.dart';
import 'package:obs_scorer_client/views/settings.dart';
import 'package:obs_scorer_client/views/widgets/summary.dart';
import 'package:obs_websocket/obs_websocket.dart';

final socketProvider = FutureProvider<ObsWebSocket>((ref) async {
  final box = ref.watch(settingsProvider);
  final socket = await ObsWebSocket.connect("ws://${box.get(ConnectionSetting.address) ?? "localhost:4455"}", password: box.get(ConnectionSetting.password));
  ref.onDispose(() {
    socket.close();
  });
  // hoping I don't need to say this because it isn't mentioned anywhere
  // await socket.init();
  // await socket.authenticate();
  return socket;
});

final gameStateProvider = Provider<GameState>((ref) {
  final box = ref.watch(settingsProvider);
  final sock = ref.watch(socketProvider).value;
  Future(() async {
    late final GameState gameState;
    try {
      gameState = ref.state;
    } catch (e) {
      gameState = const GameState();
    }
    int? awayScore;
    int? homeScore;
    String? downs;
    String? quarter;
    GameClockState? clock;
    try {
      awayScore = box.get(SourceSetting.awayScore)?.isNotEmpty == true ? await sock?.send("GetInputSettings", {"inputName": box.get(SourceSetting.awayScore)}).then((value) => int.tryParse(value?.responseData?["inputSettings"]["text"])) : null;
      homeScore = box.get(SourceSetting.homeScore)?.isNotEmpty == true ? await sock?.send("GetInputSettings", {"inputName": box.get(SourceSetting.homeScore)}).then((value) => int.tryParse(value?.responseData?["inputSettings"]["text"])) : null;
      downs = box.get(SourceSetting.downs)?.isNotEmpty == true ? await sock?.send("GetInputSettings", {"inputName": box.get(SourceSetting.downs)}).then((value) => value?.responseData?["inputSettings"]["text"]) : null;
      quarter = box.get(SourceSetting.quarter)?.isNotEmpty == true ? await sock?.send("GetInputSettings", {"inputName": box.get(SourceSetting.quarter)}).then((value) => value?.responseData?["inputSettings"]["text"]) : null;
      final clockString = box.get(SourceSetting.clock)?.isNotEmpty == true ? await sock?.send("GetInputSettings", {"inputName": box.get(SourceSetting.clock)}).then((value) => value?.responseData?["inputSettings"]["text"]) : null;
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
    ref.state = ref.state.copyWith(
      clock: clock ?? gameState.clock,
      awayScore: awayScore ?? gameState.awayScore,
      homeScore: homeScore ?? gameState.homeScore,
      downs: downs ?? gameState.downs,
      quarter: quarter ?? gameState.quarter,
    );
  });
  try {
    return ref.state;
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
          const Center(child: Padding(padding: EdgeInsets.all(16.0), child: GameStateSummaryWidget()))
        ],
      ),
    );
  }
}