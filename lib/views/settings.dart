import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hive/hive.dart';
import 'package:obs_scorer_client/src/settings.dart';

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
            ModalSettingsTile(
              title: "Away team",
              subtitle: 'Score, logo, timeout sources',
              leading: const Icon(Icons.drive_eta),
              children: [
                TextInputSettingsTile(
                  title: "Score source name",
                  settingKey: SourceSetting.awayScore,
                ),
                TextInputSettingsTile(
                  title: "Logo source name (optional)",
                  settingKey: SourceSetting.awayLogo,
                ),
              ]
            ),
            ModalSettingsTile(
              title: "Home team",
              subtitle: 'Score, logo, timeout sources',
              leading: const Icon(Icons.home),
              children: [
                TextInputSettingsTile(
                  title: "Score source name",
                  settingKey: SourceSetting.homeScore,
                ),
                TextInputSettingsTile(
                  title: "Logo source name (optional)",
                  settingKey: SourceSetting.homeLogo,
                ),
              ]
            ),
            SimpleSettingsTile(
              title: "Time & downs",
              subtitle: 'Clock and downs information',
              leading: const Icon(Icons.timer),
              child: SettingsScreen(title: "Time & downs", children: [
                TextInputSettingsTile(
                  title: "Downs source name (text)",
                  settingKey: SourceSetting.downs,
                ),
                TextInputSettingsTile(
                  title: "Downs container source name (optional)",
                  settingKey: SourceSetting.downsContainer,
                ),
                SwitchSettingsTile(
                  title: "Uppercase downs (i.e. 1ST & 10)",
                  settingKey: BehaviorSetting.uppercaseDowns
                ),
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
                  settingKey: BehaviorSetting.uppercaseQuarter
                )
              ])
            ),
          ],
        ),
        SimpleSettingsTile(
          title: "Licenses",
          subtitle: 'View licenses for all used libraries',
          leading: const Icon(Icons.article_outlined),
          child: const LicensePage(),
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