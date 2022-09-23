import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:obs_scorer_client/main.dart';
import 'package:obs_scorer_client/src/state_class.dart';
import 'package:obs_scorer_client/views/home.dart';
import 'package:obs_scorer_client/src/settings.dart';

class ClockEditorCard extends ConsumerWidget {
  final GameClockState clock;
  const ClockEditorCard({Key? key, required this.clock}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // style: TextButton.styleFrom(foregroundColor: Colors.green),
                  TextButton(onPressed: () => modSeconds(ref, -60), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text("-60")),
                  TextButton(onPressed: () => modSeconds(ref, -10), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text("-10")),
                  TextButton(onPressed: () => modSeconds(ref, -5), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text("-5")),
                  TextButton(onPressed: () => modSeconds(ref, -1), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text("-1")),
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
                          setClock(ref, int.parse(split[0]));
                        }
                        // if there's a colon, assume it's minutes:seconds
                        else if (split.length == 2) {
                          if (int.tryParse(split[0]) == null || int.tryParse(split[1]) == null) return;
                          setClock(ref, int.parse(split[1]), int.parse(split[0]));
                        }
                      },
                      controller: TextEditingController(text: clock.toString()),
                    ),
                  ),
                  TextButton(onPressed: () => modSeconds(ref, 1), style: TextButton.styleFrom(foregroundColor: Colors.green), child: const Text("+1")),
                  TextButton(onPressed: () => modSeconds(ref, 5), style: TextButton.styleFrom(foregroundColor: Colors.green), child: const Text("+5")),
                  TextButton(onPressed: () => modSeconds(ref, 10), style: TextButton.styleFrom(foregroundColor: Colors.green), child: const Text("+10")),
                  TextButton(onPressed: () => modSeconds(ref, 60), style: TextButton.styleFrom(foregroundColor: Colors.green), child: const Text("+60")),
                ]
              ),
              Wrap(
                children: [
                  TextButton(onPressed: () => setClock(ref, GameClockState(clock.minutes, 0).toSeconds()), style: TextButton.styleFrom(foregroundColor: Colors.blue), child: const Text(":00")),
                  TextButton(onPressed: () => setClock(ref, GameClockState(clock.minutes, 15).toSeconds()), style: TextButton.styleFrom(foregroundColor: Colors.blue), child: const Text(":15")),
                  TextButton(onPressed: () => setClock(ref, GameClockState(clock.minutes, 30).toSeconds()), style: TextButton.styleFrom(foregroundColor: Colors.blue), child: const Text(":30")),
                  TextButton(onPressed: () => setClock(ref, GameClockState(clock.minutes, 45).toSeconds()), style: TextButton.styleFrom(foregroundColor: Colors.blue), child: const Text(":45")),
                ],
              ),

            ],
          ),
        )
      )
    );
  }

  Future<void> modSeconds(WidgetRef ref, int amount) => setClock(ref, clock.toSeconds() + amount);
  Future<void> setClock(WidgetRef ref, int seconds, [int minutes = 0]) async {
    final source = ref.read<Box>(settingsProvider).source.clock;
    if (source == null) {
      return;
    }
    seconds = seconds + (minutes * 60);
    await (ref.read(socketProvider).value?.inputs.setText(source, GameClockState.fromSeconds(seconds).toString()) ?? Future.value());
    refreshGameState(ref);
    return;
  }
}