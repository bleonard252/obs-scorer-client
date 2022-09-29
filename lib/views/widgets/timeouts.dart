import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obs_scorer_client/main.dart';
import 'package:obs_scorer_client/views/home.dart';

class TimeoutEditorCard extends ConsumerWidget {
  final int timeouts;
  final String title;
  final String setting;
  final bool disabled;
  const TimeoutEditorCard({Key? key, this.timeouts = 0, this.title = "Score", required this.setting, this.disabled = false}) : super(key: key);

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
                IconButton(onPressed: () => callTimeout(ref, 1), icon: const Icon(Icons.chevron_left, color: Colors.red)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Checkbox(value: timeouts >= 1, onChanged: null),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Checkbox(value: timeouts >= 2, onChanged: null),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Checkbox(value: timeouts >= 3, onChanged: null),
                ),
                IconButton(onPressed: () => callTimeout(ref, -1), icon: const Icon(Icons.chevron_right, color: Colors.green)),
              ]),
            ],
          ),
        )
      )
    );
  }

  Future<void> callTimeout(WidgetRef ref, int amount) {
    assert(!disabled);
    return setTimeouts(ref, timeouts - amount);
  }
  Future<void> setTimeouts(WidgetRef ref, int value) async {
    assert(!disabled);
    final prefix = ref.read(settingsProvider).get(setting);
    if (prefix == null) {
      return;
    }
    //await (ref.read(socketProvider).value?.inputs.setText(source, value.toString()) ?? Future.value());
    const _temp = 3;
    for (var i = 0; i < _temp; i++) {
      late final bool enabled;
      final index = _temp-i;
      if (index <= value) {
        enabled = true;
      } else {
        enabled = false;
      }
      await (ref.read(socketProvider).value?.sceneItems.setVisible(prefix+(index.toString()), enabled) ?? Future.value());
    }
    refreshGameState(ref);
    return;
  }
}