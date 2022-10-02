import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obs_scorer_client/main.dart';
import 'package:obs_scorer_client/src/settings.dart';
import 'package:obs_scorer_client/views/home.dart';
import 'package:pinelogger/pinelogger.dart';
import 'package:pinelogger_flutter/pinelogger_flutter.dart';

class TopTextCard extends ConsumerStatefulWidget {
  const TopTextCard({super.key});

  @override
  ConsumerState<TopTextCard> createState() => _TopTextCardState();
}

class _TopTextCardState extends ConsumerState<TopTextCard> {
  final TextEditingController _controller = TextEditingController();
  late Pinelogger logger;

  @override
  Widget build(BuildContext context) {
    final box = ref.watch(settingsProvider);
    logger = context.logger;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Top Text',
                ),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  if (box.source.awayTopText?.isEmpty == false) TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.green),
                    onPressed: () => sendText(_AHN.AWAY),
                    child: const Text('Away'),
                  ),
                  if (box.source.homeTopText?.isEmpty == false) TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.green),
                    onPressed: () => sendText(_AHN.HOME),
                    child: const Text('Home'),
                  ),
                  if (box.source.neutralTopText?.isEmpty == false) TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.blue),
                    onPressed: () => sendText(_AHN.NEUTRAL),
                    child: const Text('Neutral'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: () => clear(),
                    child: const Text('Clear'),
                  ),
                ],
              )
            ],
          )
        )
      )
    );
  }

  Future<void> sendText(_AHN team) async {
    if (_controller.text.isEmpty) return;
    late final String? textSource;
    late final String? containerSource;
    late final String? containerScene;
    final box = ref.read(settingsProvider);
    switch (team) {
      case _AHN.AWAY:
        textSource = box.source.awayTopText;
        containerSource = box.source.awayTopTextContainer;
        containerScene = box.scene.awayTopTextScene;
        break;
      case _AHN.HOME:
        textSource = box.source.homeTopText;
        containerSource = box.source.homeTopTextContainer;
        containerScene = box.scene.homeTopTextScene;
        break;
      case _AHN.NEUTRAL:
        textSource = box.source.neutralTopText;
        containerSource = box.source.neutralTopTextContainer;
        containerScene = box.scene.neutralTopTextScene;
    }
    if (textSource == null || containerSource == null) return;
    final text = _controller.text;

    await clear(false);
    try {
      await ref.read(socketProvider).value?.inputs.setText(textSource, text);
      await ref.read(socketProvider).value?.sceneItems.setVisible(containerSource, true, containerScene);
    } catch (e) {
      logger.error("Error sending top text", error: e);
    }
  }

  Future<void> clear([bool clearField = true]) async {
    final box = ref.read(settingsProvider);
    try {
      if (box.source.awayTopTextContainer != null) await ref.read(socketProvider).value?.sceneItems.setVisible(box.source.awayTopTextContainer!, false, box.scene.awayTopTextScene);
      if (box.source.awayTopTextContainer != null) await ref.read(socketProvider).value?.sceneItems.setVisible(box.source.homeTopTextContainer!, false, box.scene.homeTopTextScene);
      if (box.source.awayTopTextContainer != null) await ref.read(socketProvider).value?.sceneItems.setVisible(box.source.neutralTopTextContainer!, false, box.scene.neutralTopTextScene);
      if (box.source.awayTopText != null) await ref.read(socketProvider).value?.inputs.setText(box.source.awayTopText!, '');
    } catch (e) {
      logger.error("Error clearing top text", error: e);
    }
    if (clearField) {
      setState(() {
        _controller.clear();
      });
    }
  }
}

enum _AHN { AWAY, HOME, NEUTRAL }