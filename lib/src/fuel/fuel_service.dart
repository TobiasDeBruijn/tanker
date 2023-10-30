import 'dart:async';

import 'package:localstore/localstore.dart';

class TankEntry {
  final int id, tankedAtKm;
  final DateTime tankedAt;
  final double tankedForEur, litersTanked;

  const TankEntry({required this.id, required this.litersTanked, required this.tankedAtKm, required this.tankedAt, required this.tankedForEur});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "litersTanked": litersTanked,
      "tankedAtKm": tankedAtKm,
      "tankedAtEpoch": (tankedAt.millisecondsSinceEpoch / 1000).round(),
      "tankedForEur": tankedForEur,
    };
  }

  factory TankEntry.fromMap(Map<String, dynamic> map) {
    int tankedAtEpoch = map['tankedAtEpoch'];

    return TankEntry(
      id: map['id'],
      litersTanked: map['litersTanked'],
      tankedAtKm: map['tankedAtKm'],
      tankedAt: DateTime.fromMillisecondsSinceEpoch(tankedAtEpoch * 1000, isUtc: true),
      tankedForEur: map['tankedForEur'],
    );
  }
}

class FuelService {
  final Localstore _db = Localstore.instance;

  static const String collectionName = "tankEntries";

  Future<List<TankEntry>> loadTankEntries() async {
    var f = await _db.collection(collectionName).get();
    if(f == null) {
      return [];
    }

    return f.values.map((e) => TankEntry.fromMap(e)).toList();
  }

  Future<void> addTankEntry(TankEntry entry) async {
    await _db.collection(collectionName).doc(entry.id.toString()).set(entry.toMap());
  }

  Future<void> removeTankEntry(int id) async {
    await _db.collection(collectionName).doc(id.toString()).delete();
  }
}