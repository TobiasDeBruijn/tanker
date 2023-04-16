import 'package:tanker/src/fuel/fuel_controller.dart';
import 'package:tanker/src/settings/settings_controller.dart';

class Controllers {
  final SettingsController settingsController;
  final FuelController fuelController;

  const Controllers({required this.settingsController, required this.fuelController});
}