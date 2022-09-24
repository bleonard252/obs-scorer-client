import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:obs_scorer_client/main.dart';
import 'package:obs_scorer_client/src/state_class.dart';
import 'package:obs_scorer_client/views/home.dart';
import 'package:obs_scorer_client/src/settings.dart';

class ClockEditorCard extends ConsumerStatefulWidget {
  final GameClockState clock;
  const ClockEditorCard({Key? key, required this.clock}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ClockEditorCardState createState() => _ClockEditorCardState();
}

class _ClockEditorCardState extends ConsumerState<ClockEditorCard> {
  Timer timer = Timer(Duration.zero, () {});
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void start() {
    timer.cancel();
    setState(() {});
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (widget.clock.toSeconds() == 1) {
        setState(() {
          timer.cancel();
        });
      }
      modSeconds(-1);
    });
  }

  void stop() {
    timer.cancel();
    setState(() {});
    timer = Timer(Duration.zero, () {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Game Clock", style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 16),
              // LinearProgressIndicator(
              //   value: timer.isActive ? widget.clock.toSeconds() / 60 : 0,
              //   valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              // ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // style: TextButton.styleFrom(foregroundColor: Colors.green),
                  TextButton(onPressed: () => modSeconds(-60), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text("-60")),
                  TextButton(onPressed: () => modSeconds(-10), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text("-10")),
                  TextButton(onPressed: () => modSeconds(-5), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text("-5")),
                  TextButton(onPressed: () => modSeconds(-1), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text("-1")),
                  SizedBox(
                    width: 128,
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        counterText: ""
                      ),
                      maxLength: 3,
                      keyboardType: TextInputType.number,
                      // onChanged: (value) {
                      //   ref.state = ref.state.copyWith(awayScore: int.tryParse(value));
                      // },
                      onSubmitted: (value) {
                        // split the string into minutes and seconds
                        var split = value.split(":");
                        // if there's no colon, assume it's just seconds
                        if (split.length == 1) {
                          if (int.tryParse(split[0]) == null) return;
                          setClock(int.parse(split[0]));
                        }
                        // if there's a colon, assume it's minutes:seconds
                        else if (split.length == 2) {
                          if (int.tryParse(split[0]) == null || int.tryParse(split[1]) == null) return;
                          setClock(int.parse(split[1]), int.parse(split[0]));
                        }
                      },
                      controller: TextEditingController(text: widget.clock.toString()),
                    ),
                  ),
                  TextButton(onPressed: () => modSeconds(1), style: TextButton.styleFrom(foregroundColor: Colors.green), child: const Text("+1")),
                  TextButton(onPressed: () => modSeconds(5), style: TextButton.styleFrom(foregroundColor: Colors.green), child: const Text("+5")),
                  TextButton(onPressed: () => modSeconds(10), style: TextButton.styleFrom(foregroundColor: Colors.green), child: const Text("+10")),
                  TextButton(onPressed: () => modSeconds(60), style: TextButton.styleFrom(foregroundColor: Colors.green), child: const Text("+60")),
                ]
              ),
              Wrap(
                children: [
                  TextButton(onPressed: () => setClock(GameClockState(widget.clock.minutes, 0).toSeconds()), style: TextButton.styleFrom(foregroundColor: Colors.blue), child: const Text(":00")),
                  TextButton(onPressed: () => setClock(GameClockState(widget.clock.minutes, 15).toSeconds()), style: TextButton.styleFrom(foregroundColor: Colors.blue), child: const Text(":15")),
                  TextButton(onPressed: () => setClock(GameClockState(widget.clock.minutes, 30).toSeconds()), style: TextButton.styleFrom(foregroundColor: Colors.blue), child: const Text(":30")),
                  TextButton(onPressed: () => setClock(GameClockState(widget.clock.minutes, 45).toSeconds()), style: TextButton.styleFrom(foregroundColor: Colors.blue), child: const Text(":45")),
                ],
              ),
              Wrap(
                children: [
                  TextButton(onPressed: () => showLongPress(context), onLongPress: () => setClock(const GameClockState(15, 0).toSeconds()), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text("15:00")),
                  TextButton(onPressed: () => showLongPress(context), onLongPress: () => setClock(const GameClockState(8, 0).toSeconds()), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text("8:00")),
                  TextButton(onPressed: () => showLongPress(context), onLongPress: () => setClock(const GameClockState(0, 0).toSeconds()), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text("0:00")),
                ],
              ),
              if (timer.isActive) IconButton(onPressed: () => stop(), icon: const Icon(Icons.pause, color: Colors.red))
              else IconButton(onPressed: () => start(), icon: const Icon(Icons.play_arrow, color: Colors.green)),
            ],
          ),
        )
      )
    );
  }

  Future<void> modSeconds(int amount) => setClock(widget.clock.toSeconds() + amount);
  Future<void> setClock(int seconds, [int minutes = 0]) async {
    final source = ref.read<Box>(settingsProvider).source.clock;
    if (source == null) {
      return;
    }
    seconds = seconds + (minutes * 60);
    await (ref.read(socketProvider).value?.inputs.setText(source, GameClockState.fromSeconds(seconds).toString()) ?? Future.value());
    refreshGameState(ref);
    return;
  }

  void showLongPress(BuildContext context) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Long press presets to reset the clock.")));
}