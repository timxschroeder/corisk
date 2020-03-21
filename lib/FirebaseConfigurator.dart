import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:corona_tracking/model/Location.dart';
import 'package:corona_tracking/model/Patient.dart';
import 'package:corona_tracking/LocationDAO.dart';
import 'package:corona_tracking/FirestoreDAO.dart';
import 'package:corona_tracking/DAO.dart';
import 'package:corona_tracking/RiskCalculator.dart';

class FirebaseConfigurator {
  final DAO _ldao = LocationDAO();
  final DAO _fdao = FirestoreDAOImpl();

  FirebaseConfigurator() {
    FirebaseMessaging().subscribeToTopic("infected");
    FirebaseMessaging().configure(onMessage: this._onMessage);
  }

  Future<void> _onMessage(Map<String, dynamic> message) async {
    final String patientId =
        message['data']['patientId'] ?? message['patientId'];

    final List<Location> localLocations =
        (await _ldao.listAll(Location.COLLECTION_NAME))
            .map((l) => Location.fromJson(l));

    final String collection =
        "${Patient.COLLECTION_NAME}/$patientId/${Location.COLLECTION_NAME}";
    final List<Location> patientLocations =
        (await _fdao.listAll(collection)).map((l) => Location.fromJson(l));

    final RiskCalculator riskCalculator =
        RiskCalculator(localLocations, patientLocations);

    final List<Location> riskyPointz = riskCalculator.criticalPoints();
    if (riskyPointz.isNotEmpty) {
      // TODO notify user here
    }
  }
}
