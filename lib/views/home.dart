import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:obs_scorer_client/main.dart';
import 'package:obs_scorer_client/src/loggy_to_pinelogger.dart';
import 'package:obs_scorer_client/src/settings.dart';
import 'package:obs_scorer_client/src/state_class.dart';
import 'package:obs_scorer_client/views/settings.dart';
import 'package:obs_scorer_client/views/widgets/clock.dart';
import 'package:obs_scorer_client/views/widgets/downs.dart';
import 'package:obs_scorer_client/views/widgets/scores.dart';
import 'package:obs_scorer_client/views/widgets/summary.dart';
import 'package:obs_scorer_client/views/widgets/timeouts.dart';
import 'package:obs_scorer_client/views/widgets/topcard.dart';
import 'package:obs_websocket/obs_websocket.dart';

final socketProvider = FutureProvider<ObsWebSocket>((ref) async {
  final box = ref.watch(settingsProvider);
  final socket = await ObsWebSocket.connect(
    "ws://${box.connection.address ?? "localhost:4455"}", password: box.connection.password,
    logOptions: const LogOptions(LogLevel.all, stackTraceLevel: LogLevel.warning),
    printer: LoggyToPinelogger(appLogger),
  );
  ref.onDispose(() {
    socket.close();
  });
  return socket;
});

final _gameStateProvider = StreamProvider<GameState>((ref) async* {
  final gameStateLogger = appLogger.child("gameStateProvider");
  //yield const GameState(awayScore: 42);
  gameStateLogger.debug("Update triggered");
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
  int? awayTimeouts;
  int? homeTimeouts;
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
    if (box.source.awayTimeoutsPrefix?.isNotEmpty == true) {
      awayTimeouts = 0;
      if (await sock.sceneItems.getVisible("${box.source.awayTimeoutsPrefix ?? ""}1", box.scene.awayTimeouts).catchError((e) => false) == true) awayTimeouts++;
      if (await sock.sceneItems.getVisible("${box.source.awayTimeoutsPrefix ?? ""}2", box.scene.awayTimeouts).catchError((e) => false) == true) awayTimeouts++;
      if (await sock.sceneItems.getVisible("${box.source.awayTimeoutsPrefix ?? ""}3", box.scene.awayTimeouts).catchError((e) => false) == true) awayTimeouts++;
    }
    if (box.source.homeTimeoutsPrefix?.isNotEmpty == true) {
      homeTimeouts = 0;
      if (await sock.sceneItems.getVisible("${box.source.homeTimeoutsPrefix ?? ""}1", box.scene.homeTimeouts).catchError((e) => false) == true) homeTimeouts++;
      if (await sock.sceneItems.getVisible("${box.source.homeTimeoutsPrefix ?? ""}2", box.scene.homeTimeouts).catchError((e) => false) == true) homeTimeouts++;
      if (await sock.sceneItems.getVisible("${box.source.homeTimeoutsPrefix ?? ""}3", box.scene.homeTimeouts).catchError((e) => false) == true) homeTimeouts++;
    }
  } catch(e) {
    gameStateLogger.error("Error while getting data", error: e);
    return;
  }
  GameState state = const GameState();
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
  if (awayTimeouts != null) state = state.copyWith(awayTimeouts: awayTimeouts);
  if (homeTimeouts != null) state = state.copyWith(homeTimeouts: homeTimeouts);
  gameStateLogger.debug("Yielding updated state", error: state);
  yield state;
  return;
});

refreshGameState(ref) => ref.refresh(_gameStateProvider);

var _lastGameState = const GameState(clock: GameClockState(43, 21));

final gameStateProvider = Provider<GameState>((ref) {
  final gameStateLogger = appLogger.child("gameStateProvider");
  return ref.watch(_gameStateProvider).map<GameState>(
    data: (data) {
      _lastGameState = data.value;
      return data.value;
    },
    error: (e) {
      gameStateLogger.error("Error in game state", error: e.error);
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
    final box = ref.watch(settingsProvider);

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
      body: SingleChildScrollView(
        child: Column(
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
            if (box.source.awayScore?.isEmpty == false || box.source.homeScore?.isEmpty == false) Wrap(
              children: [
                if (box.source.awayScore?.isEmpty == false) ScoreEditorCard(
                  title: "Away Score",
                  score: gameState.awayScore,
                  setting: SourceSetting.awayScore,
                )
                else GestureDetector(
                  onTap: () {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title: const Text("Source not set"),
                        content: const Text("\"Away score\" is not set. Set it by going to Settings, then Away team."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    });
                  },
                  child: const ScoreEditorCard(
                    title: "Away Score",
                    setting: "",
                    disabled: true
                  ),
                ),
                if (box.source.homeScore?.isEmpty == false) ScoreEditorCard(
                  title: "Home Score",
                  score: gameState.homeScore,
                  setting: SourceSetting.homeScore,
                )
                else GestureDetector(
                  onTap: () {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title: const Text("Source not set"),
                        content: const Text("\"Home score\" is not set. Set it by going to Settings, then Home team."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    });
                  },
                  child: const ScoreEditorCard(
                    title: "Home Score",
                    setting: "",
                    disabled: true
                  ),
                )
              ],
            ),
            if (box.source.awayTimeoutsPrefix?.isEmpty == false || box.source.homeTimeoutsPrefix?.isEmpty == false) Wrap(
              children: [
                if (box.source.awayTimeoutsPrefix?.isEmpty == false) TimeoutEditorCard(
                  title: "Away Timeouts",
                  timeouts: gameState.awayTimeouts,
                  setting: SourceSetting.awayTimeoutsPrefix,
                  sceneSetting: SceneSetting.awayTimeouts,
                )
                else GestureDetector(
                  onTap: () {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title: const Text("Source not set"),
                        content: const Text("\"Away timeouts prefix\" is not set. Set it by going to Settings, then Away team."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    });
                  },
                  child: const TimeoutEditorCard(
                    title: "Away Timeouts",
                    setting: "",
                    sceneSetting: "",
                    disabled: true
                  ),
                ),
                if (box.source.homeTimeoutsPrefix?.isEmpty == false) TimeoutEditorCard(
                  title: "Home Timeouts",
                  timeouts: gameState.homeTimeouts,
                  setting: SourceSetting.homeTimeoutsPrefix,
                  sceneSetting: SceneSetting.homeTimeouts,
                )
                else GestureDetector(
                  onTap: () {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title: const Text("Source not set"),
                        content: const Text("\"Home timeouts prefix\" is not set. Set it by going to Settings, then Home team."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    });
                  },
                  child: const TimeoutEditorCard(
                    title: "Home Timeouts",
                    setting: "",
                    sceneSetting: "",
                    disabled: true
                  ),
                )
              ],
            ),
            if (box.source.awayTopText?.isEmpty == false || box.source.homeTopText?.isEmpty == false) const TopTextCard(),
            if (box.source.clock != null || box.source.quarter != null) const ClockEditorCard(),
            if (box.source.downs != null) const DownsAndDistanceEditorCard(),
          ],
        ),
      ),
    );
  }
}