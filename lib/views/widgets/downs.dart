import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:obs_scorer_client/main.dart';
import 'package:obs_scorer_client/src/settings.dart';
import 'package:obs_scorer_client/src/state_class.dart';
import 'package:obs_scorer_client/views/home.dart';

class DownsAndDistanceEditorCard extends ConsumerStatefulWidget {
  const DownsAndDistanceEditorCard({Key? key}) : super(key: key);


  @override
  _DownsAndDistanceEditorCardState createState() => _DownsAndDistanceEditorCardState();
}

class _DownsAndDistanceEditorCardState extends ConsumerState<DownsAndDistanceEditorCard> {
  late DownsState _downsState;

  @override
  void initState() {
    super.initState();
    revert();
  }

  void revert() {
    setState(() {
      _downsState = DownsState.fromString(ref.read(gameStateProvider).downs);
    });
  }

  @override
  Widget build(BuildContext context) {
    final downsOnStyle = TextButton.styleFrom(
      foregroundColor: Theme.of(context).textTheme.bodyText1?.color,
    );
    final downsOffStyle = OutlinedButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.primary,
    );
    ref.listen(gameStateProvider, (p, n) {
      if (n.downs != p?.downs) {
        revert();
      }
    });
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Downs & Distance", style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 16),
              const Text("Downs"),
              Wrap(
                //alignment: WrapAlignment.center,
                children: [
                  if (_downsState.down == 1) OutlinedButton(onPressed: () {}, style: downsOffStyle, child: const Text("1st"))
                  else TextButton(onPressed: () => setDowns(1), style: downsOnStyle, child: const Text("1st")),
                  if (_downsState.down == 2) OutlinedButton(onPressed: () {}, style: downsOffStyle, child: const Text("2nd"))
                  else TextButton(onPressed: () => setDowns(2), style: downsOnStyle, child: const Text("2nd")),
                  if (_downsState.down == 3) OutlinedButton(onPressed: () {}, style: downsOffStyle, child: const Text("3rd"))
                  else TextButton(onPressed: () => setDowns(3), style: downsOnStyle, child: const Text("3rd")),
                  if (_downsState.down == 4) OutlinedButton(onPressed: () {}, style: downsOffStyle, child: const Text("4th"))
                  else TextButton(onPressed: () => setDowns(4), style: downsOnStyle, child: const Text("4th")),
                ],
              ),
              const SizedBox(height: 16),
              const Text("Distance"),
              Wrap(children: [
                IconButton(onPressed: () => modDistance(-10), icon: const Text("-10", style: TextStyle(color: Colors.red))),
                IconButton(onPressed: () => modDistance(-5), icon: const Text("-5", style: TextStyle(color: Colors.red))),
                IconButton(onPressed: () => modDistance(-1), icon: const Text("-1", style: TextStyle(color: Colors.red))),
                SizedBox(
                  width: 64,
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
                      if (int.tryParse(value) == null) return;
                      if ((int.tryParse(value)??0) > 0) return;
                      _downsState = DownsState(_downsState.down, int.parse(value), "");
                    },
                    controller: TextEditingController(text: _downsState.distance.toString()),
                  ),
                ),
                IconButton(onPressed: () => modDistance(1), icon: const Text("+1", style: TextStyle(color: Colors.green))),
                IconButton(onPressed: () => modDistance(5), icon: const Text("+5", style: TextStyle(color: Colors.green))),
                IconButton(onPressed: () => modDistance(10), icon: const Text("+10", style: TextStyle(color: Colors.green))),
              ]),
              const SizedBox(height: 16),
              Wrap(
                children: [
                  ElevatedButton(onPressed: () => setDownsAndDistance(_downsState), child: const Text("Update")),
                  const SizedBox(width: 16),
                  OutlinedButton(onPressed: revert, style: OutlinedButton.styleFrom(foregroundColor: Colors.red), child: const Text("Revert")),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                children: [
                  TextButton(onPressed: () => setDownsAndDistance(const DownsState(1, 10, "")), style: TextButton.styleFrom(foregroundColor: Colors.green), child: const Text("1st & 10")),
                  TextButton(onPressed: null, style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text("Flag")),
                  TextButton(onPressed: null, style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text("Review")),
                ],
              ),
            ],
          ),
        )
      )
    );
  }

  Future<void> setDowns(int downs) {
    assert(downs >= 1 && downs <= 4, "Downs must be between 1 and 4; 0 is not supported here. Got $downs");
    //return setDownsAndDistance(DownsState(downs, _downsState.distance, ""));
    setState(() {
      _downsState = DownsState(downs, _downsState.distance, "");
    });
    return Future.value();
  }
  Future<void> modDistance(int distance) {
    if (_downsState.distance + distance < 0) {
      // Reset to 1st & 10 if we go negative
      setState(() {
        _downsState = const DownsState(1, 10, "");
      });
    } else {
      setState(() {
        _downsState = DownsState(_downsState.down, _downsState.distance + distance, "");
      });
    }
    return Future.value();
  }
  Future<void> setDownsAndDistance(DownsState value) async {
    final source = ref.read(settingsProvider).source.downs;
    if (source == null) {
      return;
    }
    var string = value.toString();
    if (ref.read<Box>(settingsProvider).behavior.uppercaseDowns ?? false) {
      string = string.toUpperCase();
    }
    await (ref.read(socketProvider).value?.inputs.setText(source, string) ?? Future.value());
    refreshGameState(ref);
    return;
  }
}