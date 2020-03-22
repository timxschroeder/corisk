import 'dart:async';

import 'package:corona_tracking/model/Serializable.dart';
import 'package:meta/meta.dart';

/// Defines generic CRUD-Operations on type T.
abstract class DAO {
  Future<void> insert({@required Serializable serializable, String collectionPath});
  void delete(Serializable serializable);
  Future<List<Map<String, dynamic>>> listAll(String collectionPath);
  Future<Map<String, dynamic>> getElementByID({
    @required String collectionPath,
    @required String id,
  });
  Future<List<Map<String, dynamic>>> listAllWithTimestampIn({
    @required String collectionPath,
    @required DateTime lowerBound,
    @required DateTime upperBound,
  });
}

class NoElementsError extends Error {
  String cause;
  NoElementsError(this.cause);
}

class AmbigousElementsError extends Error {
  String cause;
  AmbigousElementsError(this.cause);
}

class InsufficientPermissionsError extends Error {
  String cause;
  InsufficientPermissionsError(this.cause);
}
