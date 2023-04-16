import 'package:flutter/material.dart';
import 'package:tanker/src/controllers.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controllers});

  final Controllers controllers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButtonFormField<ThemeMode>(
          decoration: const InputDecoration(
            label: Text("Thema"),
          ),
          value: controllers.settingsController.themeMode,
          onChanged: controllers.settingsController.updateThemeMode,
          items: const [
            DropdownMenuItem(
              value: ThemeMode.system,
              child: Text('System Theme'),
            ),
            DropdownMenuItem(
              value: ThemeMode.light,
              child: Text('Light Theme'),
            ),
            DropdownMenuItem(
              value: ThemeMode.dark,
              child: Text('Dark Theme'),
            )
          ],
        ),
      ),
    );
  }
}
