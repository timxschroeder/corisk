import 'package:corona_tracking/Serializable.dart';
import 'package:corona_tracking/database/DAO.dart';
import 'package:corona_tracking/database/LocalDatabase.dart';
import 'package:corona_tracking/model/Location.dart';
import 'package:flutter/foundation.dart';
import 'package:sembast/sembast.dart';

class LocalDAO extends DAO {
  Future<Database> get _db async => await LocalDatabase.instance.database;

  @override
  Future insert({@required Serializable serializable, String collectionPath}) async {
    collectionPath ??= serializable.collectionName;
    final _locationsFolder = intMapStoreFactory.store(collectionPath);
    await _locationsFolder.add(await _db, serializable.toJson());
    print('Insert successful');
  }

  @override
  Future delete(Serializable serializable) async {
    final _locationsFolder = intMapStoreFactory.store(serializable.collectionName);
    final finder = Finder(filter: Filter.byKey(serializable.id));
    await _locationsFolder.delete(await _db, finder: finder);
  }

  @override
  Future<List<Map<String, dynamic>>> listAll(String collectionName) async {
    final _locationsFolder = intMapStoreFactory.store(collectionName);
    final recordSnapshot = await _locationsFolder.find(await _db);
    return recordSnapshot.map((snapshot) => snapshot.value).toList();
  }

  @override
  Future<Map<String, dynamic>> getElementByID({@required String collectionPath, @required String id}) async {
    final List<Map<String, dynamic>> elementsOfCollection = await listAll(collectionPath);
    return elementsOfCollection.where((l) => l['id'] == id).first;
  }

  @override
  Future<List<Map<String, dynamic>>> listAllWithTimestampIn(
      {@required String collectionPath, @required DateTime lowerBound, @required DateTime upperBound}) async {
    final _locationsFolder = intMapStoreFactory.store(collectionPath);
    final recordSnapshot = await _locationsFolder.find(await _db);
    final jsons = recordSnapshot.map((snapshot) => snapshot.value).toList();
    return jsons
        .map((j) => Location.fromJson(j))
        .where((l) => l.position.timestamp.isAfter(lowerBound) && l.position.timestamp.isBefore(upperBound))
        .map((l) => l.toJson());
  }
}
