import 'package:background_fetch/background_fetch.dart';
import 'package:corona_tracking/database/DAO.dart';
import 'package:corona_tracking/database/FirestoreDAO.dart';
import 'package:corona_tracking/database/LocalDAO.dart';
import 'package:corona_tracking/model/CriticalMeeting.dart';
import 'package:corona_tracking/model/Location.dart';
import 'package:corona_tracking/model/Patient.dart';
import 'package:corona_tracking/redux/Actions/CriticalMeetingsActions.dart';
import 'package:corona_tracking/redux/Actions/MessageActions.dart';
import 'package:corona_tracking/redux/Actions/UISettingsActions.dart';
import 'package:corona_tracking/redux/AppState.dart';
import 'package:corona_tracking/redux/Middleware/criticalMeetingsMiddleware.dart';
import 'package:corona_tracking/redux/Middleware/messageMiddleware.dart';
import 'package:corona_tracking/redux/Middleware/uiSettingsMiddleware.dart';
import 'package:corona_tracking/screens/OnboardingScreen.dart';
import 'package:corona_tracking/utilities/MeetingDetector.dart';
import 'package:corona_tracking/utilities/Notificator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

const EVENTS_KEY = "fetch_events";

/// This "Headless Task" is run when app is terminated.
void backgroundFetchHeadlessTask(String taskId) async {
  print("[BackgroundFetch] Headless event received: $taskId");
  print("Corona Tracking");
  DateTime timestamp = DateTime.now();

  // Read fetch_events from SharedPreferences
  List<String> events = [];
  // Add new event.
  events.insert(0, "$taskId@$timestamp [Headless]");
  // Persist fetch events in SharedPreferences

  BackgroundFetch.finish(taskId);

  if (taskId == 'flutter_background_fetch') {
    BackgroundFetch.scheduleTask(
      TaskConfig(
        taskId: "com.transistorsoft.customtask",
        delay: 5000,
        periodic: false,
        forceAlarmManager: true,
        stopOnTerminate: false,
        enableHeadless: true,
      ),
    );
  }
}

final Store<AppState> store = Store<AppState>(
  stateReducer,
  initialState: AppState.initialState(),
  middleware: []
    ..addAll(createUISettingsMiddleware())
    ..addAll(createCriticalMeetingsMiddleware())
    ..addAll(createMessageMiddleware()),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(App(store));

  // Register to receive BackgroundFetch events after app is terminated.
  // Requires {stopOnTerminate: false, enableHeadless: true}
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

Future<dynamic> onMessage(Map<String, dynamic> message) async {
  final DAO _ldao = LocalDAO();
  final DAO _fdao = FirestoreDAOImpl();
  print('message received: $message');
  final String patientId = message['data']['patientId'] ?? message['patientId'];

  final List<Location> localLocations =
      (await _ldao.listAll(Location.COLLECTION_NAME)).map((l) => Location.fromJson(l)).toList();

  final String collection = "${Patient.COLLECTION_NAME}/$patientId/${Location.COLLECTION_NAME}";
  final List<Location> patientLocations = (await _fdao.listAll(collection)).map((l) => Location.fromJson(l));

  final MeetingDetector riskCalculator = MeetingDetector(localLocations, patientLocations);

  final List<CriticalMeeting> criticalMeetings = riskCalculator.criticalPoints();
  if (criticalMeetings.isNotEmpty) {
    store.dispatch(AddCriticalMeetingsAction(criticalMeetings));

    final note = Notificator();
    await note.showNotification(
        'Gefahr erkannt', 'In ihrem Bewegungsprofil gibt es Überscheidungen mit Corona-Patienten');
  }
}

class App extends StatelessWidget {
  final Store<AppState> store;

  App(this.store);
  @override
  Widget build(BuildContext context) {
    Notificator().init();
    //configurator.subscribe("infections");
    store.dispatch(InitializeUISettingsAction());
    store.dispatch(LoadCriticalMeetingsAction());
    store.dispatch(ConfigureMessageHandlerAction(topic: "infected", onMessage: onMessage));
    store.dispatch(UpdateDeviceMessagingTokenAction());

    // TODO check if user has seen onboarding before
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: "Corisk",
        debugShowCheckedModeBanner: false,
        home: OnboardingScreen(),
      ),
    );
  }
}
