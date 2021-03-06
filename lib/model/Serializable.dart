import 'package:corona_tracking/utilities/uuid.dart';

/// Every Object that is stored in the database needs to extend from this class.
/// The collectionName is used by {DAO} to refer to the collection in the database.
abstract class Serializable {
  String collectionName;

  String id;

  Serializable() : id = Uuid().generateV4();

  toJson();
}
