import 'package:flutter/material.dart';
import 'package:tanker/src/fuel/fuel_service.dart';

class FuelController with ChangeNotifier {
  FuelController(this._fuelService);
  final FuelService _fuelService;

  List<TankEntry> _tankEntries = [];
  List<TankEntry> get tankEntries => _tankEntries;

  double getAvgKmPerLiter() {
    int totalKm = _getTotalKm();
    double totalLiter = _getTotalLiter();

    return totalKm.abs() / totalLiter.abs();
  }
  
  double getAvgEurPerLiter() {
    double allAvgs = tankEntries
        .map((e) => e.tankedForEur / e.litersTanked)
        .toList()
        .fold(0, (previous, current) => previous + current);

    return allAvgs / tankEntries.length;
  }

  int _getTotalKm() {
    return tankEntries.isNotEmpty ? tankEntries.first.tankedAtKm - tankEntries.last.tankedAtKm : 0;
  }
  
  double _getTotalLiter() {
    return tankEntries
        .map((e) => e.litersTanked)
        .fold(0, (previous, current) => previous + current);
  }

  Future<void> loadTankEntries() async {
    _tankEntries = await _fuelService.loadTankEntries();
    notifyListeners();
  }

  Future<void> addTankEntry(TankEntry tankEntry) async {
    _tankEntries.add(tankEntry);
    notifyListeners();
    await _fuelService.addTankEntry(tankEntry);
  }

  Future<void> deleteTankEntry(int tankEntryId) async {
    _tankEntries = _tankEntries.where((element) => element.id != tankEntryId).toList();
    notifyListeners();
    await _fuelService.removeTankEntry(tankEntryId);
  }
}
