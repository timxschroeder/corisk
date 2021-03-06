import 'package:corona_tracking/model/Serializable.dart';
import 'package:geolocator/geolocator.dart';

class Location extends Serializable {
  /// for DAO-Call
  static const String COLLECTION_NAME = "Location";

  /// for DAO-intern
  @override
  String get collectionName => COLLECTION_NAME;

  final Position position;

  @override
  String toString() {
    return 'Location{id: $id, position: $position}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location && runtimeType == other.runtimeType && id == other.id && position == other.position;

  @override
  int get hashCode => id.hashCode ^ position.hashCode;

  Location(this.position);

  Location.fromJson(Map<String, dynamic> json)
      : this.position = Position.fromMap(json['position']),
        super() {
    this.id = json['id'];
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'position': position.toJson(),
      };
}
