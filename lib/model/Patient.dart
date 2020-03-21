import 'package:corona_tracking/Serializable.dart';

class Patient extends Serializable {
  /// for DAO-Call
  static const String COLLECTION_NAME = "Patient";

  /// for DAO-intern
  @override
  String get collectionName => COLLECTION_NAME;

  Patient();

  toJson() {
    return;
  }

  @override
  fromJsonInternal(Map<String, dynamic> json) {
    return Patient();
  }
}
