import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obs_scorer_client/views/home.dart';

class GameStateSummaryWidget extends ConsumerWidget {
  const GameStateSummaryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameStateProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(state.downs, style: Theme.of(context).textTheme.labelLarge),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("AWAY", style: Theme.of(context).textTheme.overline),
                Text(state.awayScore.toString(), style: Theme.of(context).textTheme.headline4),
              ],
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("HOME", style: Theme.of(context).textTheme.overline),
                Text(state.homeScore.toString(), style: Theme.of(context).textTheme.headline4),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.quarter, style: Theme.of(context).textTheme.bodyText1),
            const SizedBox(width: 32),
            Text(state.clock.toString(), style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ],
    );
  }
}