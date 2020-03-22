import 'package:corona_tracking/model/CriticalMeeting.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:corona_tracking/model/Location.dart';
import 'package:corona_tracking/Notificator.dart';
import 'package:corona_tracking/model/Patient.dart';
import 'package:corona_tracking/LocationDAO.dart';
import 'package:corona_tracking/FirestoreDAO.dart';
import 'package:corona_tracking/DAO.dart';

import 'package:corona_tracking/MeetingDetector.dart';

class FirebaseConfigurator {
  final DAO _ldao = LocationDAO();
  final DAO _fdao = FirestoreDAOImpl();

  FirebaseConfigurator() {
    FirebaseMessaging().subscribeToTopic("infections");
    FirebaseMessaging().configure(onMessage: this._onMessage);
  }

  Future<void> _onMessage(Map<String, dynamic> message) async {
    // TODO Android und ios berücksichtigen
    // TODO Berechtigungen für iOS Benachrichtigungen

    final String patientId =
        message['data']['patientId'] ?? message['patientId'];

    final List<Location> localLocations =
        (await _ldao.listAll(Location.COLLECTION_NAME))
            .map((l) => Location.fromJson(l));

    final String collection =
        "${Patient.COLLECTION_NAME}/$patientId/${Location.COLLECTION_NAME}";
    final List<Location> patientLocations =
        (await _fdao.listAll(collection)).map((l) => Location.fromJson(l));

    final MeetingDetector riskCalculator =
        MeetingDetector(localLocations, patientLocations);

    final List<CriticalMeeting> riskyPointz = riskCalculator.criticalPoints();
    if (riskyPointz.isNotEmpty) {
      // TODO put into local store
      final note = Notificator();
      await note.showNotification('Gefahr erkannt', 'In ihrem Bewegungsprofil gibt es Überscheidungen mit Corona-Patienten');
    }
  }
}
