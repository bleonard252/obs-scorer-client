import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hive/hive.dart';
import 'package:obs_scorer_client/main.dart';
import 'package:obs_scorer_client/src/settings.dart';
import 'package:obs_scorer_client/src/sync.dart';
import 'package:obs_scorer_client/views/home.dart';
import 'package:obs_scorer_client/views/logs.dart';
import 'package:pinelogger_flutter/pinelogger_flutter.dart';

import 'login.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return SettingsScreen(
      title: "OBS Scorer Client Settings",
      children: [
        SettingsGroup(
          title: "Components",
          children: [
            SimpleSettingsTile(
              title: "Away team",
              subtitle: 'Score, logo, timeout sources',
              leading: const Icon(Icons.drive_eta),
              child: SettingsScreen(title: "Clock", children: [
                TextInputSettingsTile(
                  title: "Score source name",
                  settingKey: SourceSetting.awayScore,
                ),
                TextInputSettingsTile(
                  title: "Logo source name (optional)",
                  settingKey: SourceSetting.awayLogo,
                ),
                TextInputSettingsTile(
                  title: "Timeout source name prefix (optional; as-is)",
                  settingKey: SourceSetting.awayTimeoutsPrefix,
                ),
                TextInputSettingsTile(
                  title: "Timeout container or scene (defaults to current scene)",
                  settingKey: SceneSetting.awayTimeouts,
                ),
                SettingsGroup(
                  title: "Top Text",
                  children: [
                    TextInputSettingsTile(
                      title: "Top text source",
                      settingKey: SourceSetting.awayTopText,
                    ),
                    TextInputSettingsTile(
                      title: "Top text container",
                      settingKey: SourceSetting.awayTopTextContainer,
                    ),
                    TextInputSettingsTile(
                      title: "Top text container scene",
                      settingKey: SceneSetting.awayTopTextScene,
                    ),
                  ]
                )
              ])
            ),
            SimpleSettingsTile(
              title: "Home team",
              subtitle: 'Score, logo, timeout sources',
              leading: const Icon(Icons.home),
              child: SettingsScreen(title: "Home team", children: [
                TextInputSettingsTile(
                  title: "Score source name",
                  settingKey: SourceSetting.homeScore,
                ),
                TextInputSettingsTile(
                  title: "Logo source name (optional)",
                  settingKey: SourceSetting.homeLogo,
                ),
                TextInputSettingsTile(
                  title: "Timeout source name prefix (optional; as-is)",
                  settingKey: SourceSetting.homeTimeoutsPrefix,
                ),
                TextInputSettingsTile(
                  title: "Timeout container or scene (defaults to current scene)",
                  settingKey: SceneSetting.homeTimeouts,
                ),
                SettingsGroup(
                  title: "Top Text",
                  children: [
                    TextInputSettingsTile(
                      title: "Top text source",
                      settingKey: SourceSetting.homeTopText,
                    ),
                    TextInputSettingsTile(
                      title: "Top text container",
                      settingKey: SourceSetting.homeTopTextContainer,
                    ),
                    TextInputSettingsTile(
                      title: "Top text container scene",
                      settingKey: SceneSetting.homeTopTextScene,
                    ),
                  ]
                )
              ])
            ),
            SimpleSettingsTile(
              title: "Clock",
              subtitle: 'Clock information',
              leading: const Icon(Icons.timer),
              child: SettingsScreen(title: "Clock", children: [
                TextInputSettingsTile(
                  title: "Clock source name",
                  settingKey: SourceSetting.clock,
                ),
                TextInputSettingsTile(
                  title: "Quarter source name",
                  settingKey: SourceSetting.quarter,
                ),
                SwitchSettingsTile(
                  title: "Uppercase quarter (i.e. 1ST)",
                  enabledLabel: '1ST; 2ND; 3RD; 4TH; OT',
                  disabledLabel: '1st; 2nd; 3rd; 4th; OT',
                  settingKey: BehaviorSetting.uppercaseQuarter
                )
              ])
            ),
            SimpleSettingsTile(
              title: "Downs, flag, review",
              subtitle: 'Information typically displayed on the "downs" line',
              leading: const Icon(Icons.flag),
              child: SettingsScreen(title: "Downs, flag, review", children: [
                SettingsGroup(title: "Downs", children: [
                  TextInputSettingsTile(
                    title: "Downs source name (text)",
                    settingKey: SourceSetting.downs,
                  ),
                  TextInputSettingsTile(
                    title: "Downs container source name (optional)",
                    settingKey: SourceSetting.downsContainer,
                  ),
                  TextInputSettingsTile(
                    title: "Downs scene name (defaults to current scene)",
                    settingKey: SceneSetting.downsScene,
                  ),
                  SwitchSettingsTile(
                    title: "Uppercase downs (i.e. 1ST & 10)",
                    enabledLabel: '1ST & 10; 2ND DOWN',
                    disabledLabel: '1st & 10; 2nd Down',
                    settingKey: BehaviorSetting.uppercaseDowns
                  ),
                  SwitchSettingsTile(
                    title: "Hide downs on Basic",
                    enabledLabel: 'Downs hidden on Basic',
                    disabledLabel: 'Downs placeholder text shown on Basic',
                    settingKey: BehaviorSetting.hideDownsWhenNone,
                  ),
                  TextInputSettingsTile(
                    title: "Downs placeholder text (optional)",
                    settingKey: BehaviorSetting.textWhenNoDowns,
                  )
                ]),
                SettingsGroup(
                  title: "Flag",
                  children: [
                    TextInputSettingsTile(
                      title: "Flag source name (text)",
                      settingKey: SourceSetting.flagThrown,
                    ),
                    TextInputSettingsTile(
                      title: "Flag scene/group name (defaults to downs scene)",
                      settingKey: SceneSetting.flagScene,
                    ),
                  ],
                ),
                SettingsGroup(
                  title: "Review",
                  children: [
                    TextInputSettingsTile(
                      title: "Review source name (text)",
                      settingKey: SourceSetting.review,
                    ),
                    TextInputSettingsTile(
                      title: "Review scene/group name (defaults to flag scene/group)",
                      settingKey: SceneSetting.reviewScene,
                    ),
                  ],
                ),
                SettingsGroup(
                  title: "Neutral Top Text",
                  children: [
                    TextInputSettingsTile(
                      title: "Top text source",
                      settingKey: SourceSetting.neutralTopText,
                    ),
                    TextInputSettingsTile(
                      title: "Top text container",
                      settingKey: SourceSetting.neutralTopTextContainer,
                    ),
                    TextInputSettingsTile(
                      title: "Top text container scene",
                      settingKey: SceneSetting.neutralTopTextScene,
                    ),
                  ]
                )
              ])
            )
          ],
        ),
        Consumer(
          builder: (context, ref, _) {
            return SettingsGroup(
              title: "Settings Sync",
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor.withAlpha(20), width: 0.9))
                  ),
                  child: ListTile(
                    title: Text("Push/Send settings to OBS", style: headerTextStyle(context)),
                    subtitle: Text(
                      "Saved in the current Profile, and limited to the current Scene Collection.",
                      style: subtitleTextStyle(context)
                    ),
                    leading: const Icon(Icons.upload),
                    onTap: () async {
                      late final Future<void> future;
                      future = pushSettings(ref.read(settingsProvider), ref.read(socketProvider).value!);
                      await showDialog(
                        context: context,
                        builder: (context) => FutureProgressDialog(future, message: "Sending settings to OBS...", failureMessage: "Could not push settings to OBS."),
                      );
                      // ignore: use_build_context_synchronously
                      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Settings pushed to OBS.")));
                    },
                  ),
                ),
                ListTile(
                  title: Text("Pull/Get settings from OBS", style: headerTextStyle(context)),
                  subtitle: Text(
                    "Saved in the current Profile, and limited to the current Scene Collection.\n"
                    "This is done automatically when you log in, so unless you changed and pushed settings on another device, "
                    "you shouldn't have to do this.",
                    style: subtitleTextStyle(context)
                  ),
                  isThreeLine: true,
                  leading: const Icon(Icons.download),
                  onTap: () async {
                    late final Future<void> future;
                    future = pullSettings(ref.read(settingsProvider), ref.read(socketProvider).value!);
                    await showDialog(
                      context: context,
                      builder: (context) => FutureProgressDialog(future, message: "Receiving settings from OBS...", failureMessage: "Could not pull settings from OBS."),
                    );
                    // ignore: use_build_context_synchronously
                    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Settings pulled from OBS.")));
                    ref.refresh(settingsProvider);
                      // refresh everything that uses settings
                      // (except the settings screen I guess)
                  },
                ),
              ]
            );
          }
        ),
        Divider(thickness: 2, color: Theme.of(context).dividerColor.withAlpha(20)),
        SimpleSettingsTile(
          title: "Licenses",
          subtitle: 'View licenses for all used libraries',
          leading: const Icon(Icons.article_outlined),
          child: const LicensePage(),
        ),
        SimpleSettingsTile(
          title: "Logs",
          subtitle: 'Useful for troubleshooting',
          leading: const Icon(Icons.code),
          child: const LogView(),
        ),
        ListTile(
          title: Text("Log out", style: headerTextStyle(context)?.copyWith(color: Colors.red)),
          leading: const Icon(Icons.logout),
          iconColor: Colors.red,
          textColor: Colors.red,
          onTap: () {
            showDialog(context: context, builder: (context) => AlertDialog(
              title: const Text("Are you sure you want to log out?"),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.pop(context, false),
                ),
                TextButton(
                  child: const Text("Log out"),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ],
            )).then((value) {
              if (!value) return;
              Hive.box("settings").delete(ConnectionSetting.address);
              Hive.box("settings").delete(ConnectionSetting.password);
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginView()));
            });
          },
        ),
      ],
    );
  }

  TextStyle? headerTextStyle(BuildContext context) =>
    Theme.of(context).textTheme.headline6?.copyWith(fontSize: 16.0);

  TextStyle? subtitleTextStyle(BuildContext context) => Theme.of(context)
    .textTheme
    .subtitle2
    ?.copyWith(fontSize: 13.0, fontWeight: FontWeight.normal);

}

class FutureProgressDialog extends StatelessWidget {
  final Future<void> future;
  final String message;
  final String? failureMessage;

  const FutureProgressDialog(this.future, {Key? key, required this.message, this.failureMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logger = context.logger;
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          logger.error(failureMessage ?? "Failed: $message", error: snapshot.error);
          return AlertDialog(
            title: Text(message),
            content: Text(snapshot.error.toString()),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Navigator.pop(context);
          return const SizedBox.shrink();
        }
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(value: null),
              const SizedBox(width: 16),
              Text(message),
            ],
          ),
        );
      },
    );
  }
}