import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obs_scorer_client/main.dart';
import 'package:obs_scorer_client/views/home.dart';

class ScoreEditorCard extends ConsumerWidget {
  final int score;
  final String title;
  final String setting;
  final bool disabled;
  const ScoreEditorCard({Key? key, this.score = 0, this.title = "Score", required this.setting, this.disabled = false}) : super(key: key);

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
              Text(title, style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 16),
              Wrap(children: [
                IconButton(onPressed: disabled ? null : () => modScore(ref, -6), icon: const Text("-6", style: TextStyle(color: Colors.red))),
                IconButton(onPressed: disabled ? null : () => modScore(ref, -3), icon: const Text("-3", style: TextStyle(color: Colors.red))),
                IconButton(onPressed: disabled ? null : () => modScore(ref, -2), icon: const Text("-2", style: TextStyle(color: Colors.red))),
                IconButton(onPressed: disabled ? null : () => modScore(ref, -1), icon: const Text("-1", style: TextStyle(color: Colors.red))),
                SizedBox(
                  width: 64,
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      counterText: ""
                    ),
                    enabled: !disabled,
                    maxLength: 3,
                    keyboardType: TextInputType.number,
                    // onChanged: (value) {
                    //   ref.state = ref.state.copyWith(awayScore: int.tryParse(value));
                    // },
                    onSubmitted: disabled ? null : (value) {
                      if (int.tryParse(value) == null) return;
                      setScore(ref, int.parse(value));
                    },
                    controller: TextEditingController(text: disabled ? "" : score.toString()),
                  ),
                ),
                IconButton(onPressed: disabled ? null : () => modScore(ref, 1), icon: const Text("+1", style: TextStyle(color: Colors.green))),
                IconButton(onPressed: disabled ? null : () => modScore(ref, 2), icon: const Text("+2", style: TextStyle(color: Colors.green))),
                IconButton(onPressed: disabled ? null : () => modScore(ref, 3), icon: const Text("+3", style: TextStyle(color: Colors.green))),
                IconButton(onPressed: disabled ? null : () => modScore(ref, 6), icon: const Text("+6", style: TextStyle(color: Colors.green))),
              ]),
            ],
          ),
        )
      )
    );
  }

  Future<void> modScore(WidgetRef ref, int amount) {
    assert(!disabled);
    return setScore(ref, score + amount);
  }
  Future<void> setScore(WidgetRef ref, int value) async {
    assert(!disabled);
    final source = ref.read(settingsProvider).get(setting);
    if (source == null) {
      return;
    }
    await (ref.read(socketProvider).value?.inputs.setText(source, value.toString()) ?? Future.value());
    refreshGameState(ref);
    return;
  }
}