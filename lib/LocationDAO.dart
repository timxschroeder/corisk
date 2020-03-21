import 'package:corona_tracking/LocalDatabase.dart';
import 'package:corona_tracking/Location.dart';
import 'package:sembast/sembast.dart';

class LocationDao {
  static const String folderName = "Locations";
  final _locationsFolder = intMapStoreFactory.store(folderName);

  Future<Database> get _db async => await LocalDatabase.instance.database;

  Future insertLocation(Location location) async {
    await _locationsFolder.add(await _db, location.toJson());
    print('Location insert successful');
  }

  Future updateLocation(Location location) async {
    final finder = Finder(filter: Filter.byKey(location.id));
    await _locationsFolder.update(await _db, location.toJson(), finder: finder);
  }

  Future delete(Location location) async {
    final finder = Finder(filter: Filter.byKey(location.id));
    await _locationsFolder.delete(await _db, finder: finder);
  }

  Future<List<Location>> getAllLocations() async {
    final recordSnapshot = await _locationsFolder.find(await _db);
    return recordSnapshot.map((snapshot) => Location.fromJson(snapshot.value)).toList();
  }

  Future<List<Location>> getAllLocationsWithTimestampInRange(String valueLow, String valueHigh) async {
    final recordSnapshot = await _locationsFolder.find(await _db);
    return recordSnapshot
        .map((snapshot) => Location.fromJson(snapshot.value))
        .toList()
        .where((l) => l.timestamp >= valueLow && l.timestamp <= valueHigh);
  }
}
