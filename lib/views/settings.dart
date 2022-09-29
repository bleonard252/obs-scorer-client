import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hive/hive.dart';
import 'package:obs_scorer_client/src/settings.dart';
import 'package:obs_scorer_client/views/logs.dart';

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
                      title: "Flag scene name (defaults to downs scene)",
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
                      title: "Review scene name (defaults to flag scene)",
                      settingKey: SceneSetting.reviewScene,
                    ),
                  ],
                ),
              ])
            )
          ],
        ),
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
          title: const Text("Log out"),
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
}