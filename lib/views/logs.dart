import 'dart:math';

import 'package:flutter/material.dart';
import 'package:obs_scorer_client/main.dart';
import 'package:pinelogger/pinelogger.dart';
import 'package:pinelogger_flutter/pinelogger_flutter.dart';

class LogView extends StatefulWidget {
  const LogView({super.key});

  @override
  State<LogView> createState() => _LogViewState();
}

class _LogViewState extends State<LogView> {
  @override
  Widget build(BuildContext context) {
    final logs = appLogger;
    return Theme(
      data: ThemeData.dark(useMaterial3: false).copyWith(
        backgroundColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0.0,
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
          brightness: Brightness.dark,
          backgroundColor: Colors.black,
          accentColor: Colors.redAccent,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Logs"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder(
                stream: logs.stream,
                builder: (context, snapshot) => ListView.builder(
                  reverse: false,
                  itemCount: logs.messages.length,
                  itemBuilder: (context, index) {
                    final log = logs.messages[index];
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(log.logger.name, style: Theme.of(context).textTheme.caption),
                          if (log.message is String || log.message is Error) Text(log.message, style: TextStyle(color: log.severity.color, fontFamily: 'monospace'))
                          else Text("Something happened", style: TextStyle(color: log.severity.color)),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Text(log.level.toString()),
                          if (log.error is String) Text(log.error as String)
                          else if (log.error != null) Text(log.error.toString(), style: const TextStyle(fontFamily: 'monospace')),
                          Text("${log.severity.shortName} @ ${log.timestamp.toIso8601String()}", style: Theme.of(context).textTheme.caption),
                        ],
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(log.message.substring(0, min<int>(32, log.message.length)), style: TextStyle(color: log.severity.color)),
                            content: SingleChildScrollView(
                              //mainAxisSize: MainAxisSize.min,
                              primary: false,
                              child: Text((log.stackTrace ?? log.object ?? log.error ?? "Nothing to show").toString(), style: const TextStyle(fontFamily: "monospace")),
                            ),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}

extension on Severity {
  String get shortName => this == Severity.info
    ? "I"
    : this == Severity.warning
    ? "W"
    : this == Severity.error
    ? "E"
    : this == Severity.debug
    ? "D"
    : "V";
  Color get color => this == Severity.info
    ? Colors.blue
    : this == Severity.warning
    ? Colors.yellow
    : this == Severity.error
    ? Colors.red
    : this == Severity.debug
    ? Colors.green
    : Colors.grey;
}