import 'package:corona_tracking/Serializable.dart';

class Patient extends Serializable {
  /// for DAO-Call
  static const String COLLECTION_NAME = "Patient";

  /// for DAO-intern
  @override
  String get collectionName => COLLECTION_NAME;

  Patient();

  Patient.fromJson(Map<String, dynamic> json) : super() {
    this.id = json['id'];
  }

  @override
  Map<String, dynamic> toJson() => {'id': id};
}
