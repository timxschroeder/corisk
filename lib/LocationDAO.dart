import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corona_tracking/DAO.dart';
import 'package:corona_tracking/LocalDatabase.dart';
import 'package:corona_tracking/Serializable.dart';
import 'package:flutter/foundation.dart';
import 'package:sembast/sembast.dart';

class LocationDao extends DAO {
  Future<Database> get _db async => await LocalDatabase.instance.database;

  @override
  Future insert(Serializable serializable) async {
    final _locationsFolder = intMapStoreFactory.store(serializable.collectionName);
    await _locationsFolder.add(await _db, serializable.toJson());
    print('Location insert successful');
  }

  @override
  Future delete(Serializable serializable) async {
    final _locationsFolder = intMapStoreFactory.store(serializable.collectionName);
    final finder = Finder(filter: Filter.byKey(serializable.id));
    await _locationsFolder.delete(await _db, finder: finder);
  }

  @override
  Future<List<T>> listAll<T>(String collectionName) async {
    final _locationsFolder = intMapStoreFactory.store(collectionName);
    final recordSnapshot = await _locationsFolder.find(await _db);
    return recordSnapshot.map((snapshot) => Serializable.fromJson(snapshot.value)).toList();
  }

  Future<T> getElementByID<T>({
    @required String collectionPath,
    @required String id,
  }) {}

  @override
  Future<List<T>> listAllWithTimestampIn<T>(
      {@required String collectionName,
      @required Timestamp lowerBound,
      @required Timestamp upperBound}) async {
    final _locationsFolder = intMapStoreFactory.store(collectionName);
    final recordSnapshot = await _locationsFolder.find(await _db);
    return recordSnapshot
        .map((snapshot) => Serializable.fromJson(snapshot.value))
        .toList()
        .where((l) => l.timestamp >= lowerBound && l.timestamp <= upperBound);
  }

  /*db.collection('restaurants')
      .doc('arinell-pizza')
      .collection('ratings')
      .get()*/
}
