import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corona_tracking/Serializable.dart';
import 'package:corona_tracking/database/DAO.dart';
import 'package:flutter/foundation.dart';

/// FirestoreDAO extends the generic DAO with Firestore Collection References.
///
/// @author schroeder
/// @date 06.02.2019
abstract class FirestoreDAO extends DAO {
  CollectionReference getCollectionReference(String collectionPath) =>
      Firestore.instance.collection(collectionPath);
}

/// Concrete Implementation of {FirestoreDAO}
///
/// @author schroeder
/// @date 06.02.2019
class FirestoreDAOImpl extends FirestoreDAO {
  static final FirestoreDAOImpl _instance = FirestoreDAOImpl._internal();

  factory FirestoreDAOImpl() => _instance;

  FirestoreDAOImpl._internal();

  @override
  Future<void> insert({@required Serializable serializable, String collectionPath}) async {
    collectionPath ??= serializable.collectionName;
    final Map<String, dynamic> json = serializable.toJson();
    final CollectionReference collectionReference = getCollectionReference(collectionPath);

    await collectionReference.document(json['id']).setData(json).whenComplete(() {
      print("Inserted $json in $collectionReference");
    });
  }

  Future<void> insertObjectWithSubcollection(Serializable parent, List<Serializable> children) async {
    final Map<String, dynamic> jsonParent = parent.toJson();

    final String childCollectionPath =
        parent.collectionName + "/" + jsonParent['id'] + "/" + children.first.collectionName;

    await insert(serializable: parent);

    Future.forEach(
        children, (child) async => await insert(serializable: child, collectionPath: childCollectionPath));
  }

  @override
  void delete(Serializable serializable) {
    getCollectionReference(serializable.collectionName).document(serializable.id).delete();
  }

  @override
  Future<List<Map<String, dynamic>>> listAll(String collectionPath) async {
    final QuerySnapshot snapshot = await getCollectionReference(collectionPath).getDocuments();
    final List<DocumentSnapshot> documentSnapshots = snapshot.documents;
    final List<Map<String, dynamic>> results = [];
    documentSnapshots.forEach(
      (ds) => results.add(
        ds.data,
      ),
    );
    return results;
  }

  @override
  Future<Map<String, dynamic>> getElementByID({@required String collectionPath, @required String id}) async {
    DocumentSnapshot document;
    try {
      document = await getCollectionReference(collectionPath).document(id).get();
    } catch (e) {
      if (e.message.toString().contains("PERMISSION_DENIED")) {
        throw InsufficientPermissionsError('Access to document $id denied');
      }
    }

    if (document.exists) {
      return document.data;
    } else {
      throw NoElementsError('Document $id does not exist');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> listAllWithTimestampIn(
      {@required String collectionPath, @required DateTime lowerBound, @required DateTime upperBound}) async {
    try {
      final QuerySnapshot snapshot = await getCollectionReference(collectionPath)
          .where("Timestamp", isGreaterThan: lowerBound)
          .where("Timestamp", isLessThanOrEqualTo: upperBound)
          .getDocuments();

      final List<DocumentSnapshot> documentSnapshots = snapshot.documents;
      final List<Map<String, dynamic>> results = [];

      documentSnapshots.forEach(
        (ds) => results.add(
          ds.data,
        ),
      );
      return results;
    } on StateError {
      throw NoElementsError('No Elements selected');
    } // AmbigousElementsError goes oncaught so the caller can handle it appropriately
  }
}
