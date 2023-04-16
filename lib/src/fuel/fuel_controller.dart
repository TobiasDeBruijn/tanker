import 'package:flutter/material.dart';
import 'package:tanker/src/fuel/fuel_service.dart';

class FuelController with ChangeNotifier {
  FuelController(this._fuelService);
  final FuelService _fuelService;

  List<TankEntry> _tankEntries = [];
  List<TankEntry> get tankEntries => _tankEntries;

  double getDaysPerTank() {
    int totalDays = _getTotalHours();
    int timesTanked = tankEntries.length;
    
    return (totalDays.toDouble() / timesTanked.toDouble()) / 24;
  }

  int _getTotalHours() {
    int totalDays = 0;
    DateTime? previousDate;

    for(TankEntry tankEntry in tankEntries) {
      if(previousDate == null) {
        previousDate = tankEntry.tankedAt;
      } else {
        totalDays += tankEntry.tankedAt.difference(previousDate).inHours;
      }
    }

    return totalDays;
  }

  double getAvgKmPerLiter() {
    int totalKm = _getTotalKm(); 
    int totalLiter = _getTotalLiter();

    return totalKm.toDouble() / totalLiter.toDouble();
  }
  
  double getAvgEurPerLiter() {
    int totalLiter = _getTotalLiter();
    double totalEur = _getTotalEur();

    return totalEur / totalLiter.toDouble();
  }
  
  double _getTotalEur() {
    return tankEntries
        .map((e) => e.tankedForEur)
        .fold(0, (previous, current) => previous + current);
  }
  
  int _getTotalKm() {
    return tankEntries.isNotEmpty ? tankEntries.last.tankedAtKm - tankEntries.first.tankedAtKm : 0;
  }
  
  int _getTotalLiter() {
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
