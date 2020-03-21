

import 'package:corona_tracking/model/Location.dart';
import 'package:geolocator/geolocator.dart';

class RiskCalculator {
  final List<Location> local;
  final List<Location> other;

  RiskCalculator(this.local, this.other);

  int distance(Location l1, Location l2){
    Position p1 = l1.position;
    Position p2 = l2.position;

  }
}