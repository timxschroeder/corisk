import 'package:corona_tracking/LocalDAO.dart';
import 'package:corona_tracking/model/CriticalMeeting.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:corona_tracking/model/Location.dart';
import 'package:corona_tracking/Notificator.dart';
import 'package:corona_tracking/model/Patient.dart';
import 'package:corona_tracking/FirestoreDAO.dart';
import 'package:corona_tracking/DAO.dart';

import 'package:corona_tracking/MeetingDetector.dart';

Future<dynamic> onMessage(Map<String, dynamic> message) async {
  final DAO _ldao = LocalDAO();
  final DAO _fdao = FirestoreDAOImpl();
  print('message received: $message');
  final String patientId = message['data']['patientId'] ?? message['patientId'];

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
    await note.showNotification('Gefahr erkannt',
        'In ihrem Bewegungsprofil gibt es Überscheidungen mit Corona-Patienten');
  }
  print('no risky point found!');
}

class FirebaseConfigurator {
  final FirebaseMessaging _messaging = FirebaseMessaging();

  void init() {
    print("subscribing");
    _messaging.subscribeToTopic("infections");
    _messaging.configure(onMessage: onMessage);
  }
}
