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

enum LogViewFilter {
  gameState,
  obs
}

class _LogViewState extends State<LogView> {
  /// Filters applied to the log view.
  List<LogViewFilter> filters = [...LogViewFilter.values];
  Severity minSeverity = const Severity.all();

  @override
  Widget build(BuildContext context) {
    final logs = appLogger;
    final filteredLogs = logs.messages.where((log) {
      bool matchesAnyFilter = false;
      if (filters == [...LogViewFilter.values]) matchesAnyFilter = true;
      // if all filters are selected, show everything.
      if (filters.contains(LogViewFilter.gameState) && !matchesAnyFilter) {
        if (log.logger.name.split(".").contains("gameStateProvider")) {
          matchesAnyFilter = true;
        }
      }
      if (filters.contains(LogViewFilter.obs) && !matchesAnyFilter) {
        if (log.logger.name.split(".").contains("UI Loggy - ObsWebSocket") || log.logger.name.split(".").contains("Global Loggy")) {
          matchesAnyFilter = true;
        }
      }
      if (filters == []) {
        matchesAnyFilter = true;
        if (filters == [] && log.logger.name.split(".").contains("gameStateProvider")) matchesAnyFilter = false;
        if (filters == [] && log.logger.name.split(".").contains("UI Loggy - ObsWebSocket")) matchesAnyFilter = false;
        // inverted filters here. turning them all off shows what doesn't match any filters.
      }

      return matchesAnyFilter && log.severity >= minSeverity;
    }).toList();

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
          actions: [
            IconButton(
              tooltip: "Minimum severity",
              onPressed: () {
                final List<Severity> allKnown = [
                  const Severity.all(),
                  ...Severity.values,
                  ...logs.messages.map((e) => e.severity)
                ].unique((element) => element.index)..sort((a, b) => a.index.compareTo(b.index));

                showModalBottomSheet(context: context, builder: (context) {
                  return ListView.builder(
                    itemCount: allKnown.length,
                    itemBuilder: (context, index) {
                      final severity = allKnown[index];
                      return RadioListTile<int>(
                        title: Text(severity.name),
                        //secondary: Text(severity.index.toString()),
                        value: severity.index,
                        groupValue: minSeverity.index,
                        onChanged: (value) {
                          setState(() {
                            minSeverity = allKnown.firstWhere((element) => element.index == value, orElse: () => const Severity.all());
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                });
              },
              icon: const Icon(Icons.sort)
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilterChip(
                      label: const Text("Game state provider"),
                      onSelected: (value) => setState(() {
                        if (value) {
                          filters.add(LogViewFilter.gameState);
                        } else {
                          filters.remove(LogViewFilter.gameState);
                        }
                      }),
                      selected: filters.contains(LogViewFilter.gameState),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilterChip(
                      label: const Text("OBS Websocket"),
                      onSelected: (value) => setState(() {
                        if (value) {
                          filters.add(LogViewFilter.obs);
                        } else {
                          filters.remove(LogViewFilter.obs);
                        }
                      }),
                      selected: filters.contains(LogViewFilter.obs),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: logs.stream,
                builder: (context, snapshot) => ListView.builder(
                  reverse: true,
                  itemCount: filteredLogs.length,
                  itemBuilder: (context, index) {
                    final log = filteredLogs.reversed.elementAt(index);
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
                            title: Text(log.message.toString().substring(0, min<int>(32, log.message.length)), style: TextStyle(color: log.severity.color)),
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
    : this == Severity.verbose
    ? "V"
    : name.characters.first.toUpperCase();
  Color get color => this == Severity.info
    ? Colors.blue
    : this == Severity.warning
    ? Colors.yellow
    : this == Severity.error
    ? Colors.red
    : this == Severity.debug
    ? Colors.blueGrey
    : this == Severity.verbose
    ? Colors.purple
    : Colors.grey;
}