import 'package:corona_tracking/Serializable.dart';
import 'package:corona_tracking/model/Location.dart';

class CriticalMeeting extends Serializable {
  /// for DAO-Call
  static const String COLLECTION_NAME = "CriticalMeeting";

  /// for DAO-intern
  @override
  String get collectionName => COLLECTION_NAME;

  final Location location;

  /// in meters
  final double distance;

  CriticalMeeting(this.location, this.distance);

  @override
  String toString() {
    return 'CriticalMeeting{location: $location, distance: $distance}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CriticalMeeting &&
              runtimeType == other.runtimeType &&
              location == other.location &&
              distance == other.distance;

  @override
  int get hashCode =>
      location.hashCode ^
      distance.hashCode;

  CriticalMeeting.fromJson(Map<String, dynamic> json)
      : this.location = Location.fromJson(json['location']),
        this.distance = json['distance'],
        super() {
    this.id = json['id'];
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'distance': distance,
    'location': location.toJson(),
  };
}