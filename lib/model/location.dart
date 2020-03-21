import 'package:corona_tracking/uuid.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  final String id;
  final Position position;

  @override
  String toString() {
    return 'Location{id: $id, position: $position}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Location &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              position == other.position;

  @override
  int get hashCode =>
      id.hashCode ^
      position.hashCode;

  Location(this.position) : id=Uuid().generateV4();

  Location.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        position = Position.fromMap(json['position']);

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'position': position.toJson(),
      };
}