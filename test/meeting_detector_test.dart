import 'package:corona_tracking/utilities/MeetingDetector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  group("Distance", () {
    test("haversine distance", () {
      Position pos = Position(latitude: 53.018960, longitude: 9.397490);
      Position pos2 = Position(latitude: 53.019222, longitude: 9.397630);

      MeetingDetector calculator = MeetingDetector(null, null);
      double d = calculator.distance(pos, pos2);
      expect(d, equals(30.635414453731613));
    });
  });
}
