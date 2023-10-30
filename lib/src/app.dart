import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tanker/src/controllers.dart';
import 'package:tanker/src/fuel/fuel_view.dart';
import 'package:tanker/src/settings/settings_view.dart';

class TankerApp extends StatelessWidget {
  const TankerApp({
    super.key,
    required this.controllers,
  });

  final Controllers controllers;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controllers.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            restorationScopeId: 'app',
            theme: ThemeData(),
            darkTheme: ThemeData.dark(),
            themeMode: controllers.settingsController.themeMode,
            onGenerateRoute: _onGenerateRoute
        );
      },
    );
  }

  MaterialPageRoute<void> _onGenerateRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(
        settings: routeSettings,
        builder: _getAppLayout
    );
  }

  Widget _getAppLayout(BuildContext context) {
    return Scaffold(
      body: FuelView(controllers),
      appBar: AppBar(
        title: const Text("Tanker"),
        actions: [
          IconButton(
            icon: const Icon(MdiIcons.cog),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (builder) => SettingsView(controllers: controllers))),
          )
        ],
      ),
    );
  }
}
