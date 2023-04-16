import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tanker/src/car/car_view.dart';
import 'package:tanker/src/controllers.dart';
import 'package:tanker/src/fuel/fuel_view.dart';
import 'package:tanker/src/settings/settings_view.dart';

class TankerApp extends StatefulWidget {
  const TankerApp({
    super.key,
    required this.controllers,
  });

  final Controllers controllers;

  @override
  State<TankerApp> createState() => _TankerAppState();
}

class _TankerAppState extends State<TankerApp> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controllers.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'app',
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: widget.controllers.settingsController.themeMode,
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
      body: _getAppPages()[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (newPageIdx) => setState(() {
          _currentPageIndex = newPageIdx;
        }),
        items: _getAppPageItems()
      ),
      appBar: AppBar(
        title: Text(_getAppPageTitles()[_currentPageIndex]),
        actions: [
          IconButton(
            icon: const Icon(MdiIcons.cog),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (builder) => SettingsView(controllers: widget.controllers))),
          )
        ],
      ),
    );
  }

  List<String> _getAppPageTitles() {
    return [
      "Brandstof",
      "Auto",
    ];
  }

  List<Widget> _getAppPages() {
    return [
      FuelView(widget.controllers),
      CarView(widget.controllers),
    ];
  }

  List<BottomNavigationBarItem> _getAppPageItems() {
    return [
      const BottomNavigationBarItem(
        label: "Brandstof",
        icon: Icon(MdiIcons.gasStationOutline),
      ),
      const BottomNavigationBarItem(
        label: "Auto",
        icon: Icon(MdiIcons.car),
      )
    ];
  }
}