import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corona_tracking/Serializable.dart';
import 'package:meta/meta.dart';

/// Defines generic CRUD-Operations on type T.
///
/// @author schroeder
/// @date 17.12.2018
abstract class DAO {
  Future<void> insert(Serializable serializable);
  void delete(Serializable serializable);
  Future<List<Map<String, dynamic>>> listAll<T>(String collectionPath);
  Future<T> getElementByID<T>({
    @required String collectionPath,
    @required String id,
  });
  Future<List<T>> listAllWithTimestampIn<T>({
    @required String collectionName,
    @required Timestamp lowerBound,
    @required Timestamp upperBound,
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
