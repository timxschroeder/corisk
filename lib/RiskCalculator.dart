import 'package:corona_tracking/model/Location.dart';
import 'package:corona_tracking/model/Pair.dart';
import 'package:geolocator/geolocator.dart';

class RiskCalculator {
  final List<Location> local;
  final List<Location> other;
  final Duration _timeTreshold = Duration(seconds: 30);
  final int _distanceTreshold = 5;

  RiskCalculator(this.local, this.other);

  int distance(Location l1, Location l2) {
    Position p1 = l1.position;
    Position p2 = l2.position;
  }

  List<Location> criticalPoints() {
    final List<Pair<Location>> pairs = _locationPairsInInterval();
    List<Location> critical = [];
    for (final pair in pairs) {
      if (distance(pair.first, pair.second) < _distanceTreshold) {
        critical.add(pair.first);
      }
    }
    return critical;
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
    return l1.position.timestamp.difference(l2.position.timestamp) <
        this._timeTreshold;
  }
}
