import 'package:corona_tracking/model/CriticalMeeting.dart';
import 'package:corona_tracking/model/Location.dart';
import 'package:corona_tracking/model/Pair.dart';
import 'package:corona_tracking/utilities/Haversine.dart';
import 'package:geolocator/geolocator.dart';

class MeetingDetector {
  final List<Location> local;
  final List<Location> other;
  final Duration _timeTreshold = Duration(seconds: 30);
  final int _distanceTreshold = 5;

  MeetingDetector(
    this.local,
    this.other,
  );

  List<CriticalMeeting> criticalPoints() {
    final List<Pair<Location>> pairs = _locationPairsInInterval();
    List<CriticalMeeting> critical = [];
    for (final pair in pairs) {
      var dist = distance(pair.first.position, pair.second.position);
      if (dist < _distanceTreshold) {
        critical.add(CriticalMeeting(pair.first, dist));
      }
    }
    return critical;
  }

  /// Return haversine distance in meters.
  double distance(Position p1, Position p2) {
    final haversine = Haversine.fromDegrees(
        latitude1: p1.latitude, longitude1: p1.longitude, latitude2: p2.latitude, longitude2: p2.longitude);
    return haversine.distance();
  }

  List<Pair<Location>> _locationPairsInInterval() {
    List<Pair<Location>> pairs = [];
    for (final l1 in this.local) {
      for (final l2 in this.other) {
        if (_isBetweenInterval(l1, l2)) {
          pairs.add(Pair(l1, l2));
        }
      }
    }
    return pairs;
  }

  bool _isBetweenInterval(Location l1, Location l2) {
    return l1.position.timestamp.difference(l2.position.timestamp) < this._timeTreshold;
  }
}
