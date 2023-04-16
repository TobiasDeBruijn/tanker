import 'package:flutter/material.dart';
import 'package:tanker/src/controllers.dart';
import 'package:tanker/src/fuel/fuel_controller.dart';
import 'package:tanker/src/fuel/fuel_service.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  final fuelController = FuelController(FuelService());
  await fuelController.loadTankEntries();

  final controllers = Controllers(
    settingsController: settingsController,
    fuelController: fuelController
  );

  runApp(TankerApp(controllers: controllers));
}