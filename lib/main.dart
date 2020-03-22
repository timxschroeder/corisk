import 'package:background_fetch/background_fetch.dart';
import 'package:corona_tracking/FirebaseConfigurator.dart';
import 'package:corona_tracking/MeetingDetector.dart';
import 'package:corona_tracking/Notificator.dart';
import 'package:corona_tracking/database/DAO.dart';
import 'package:corona_tracking/database/FirestoreDAO.dart';
import 'package:corona_tracking/database/LocalDAO.dart';
import 'package:corona_tracking/model/CriticalMeeting.dart';
import 'package:corona_tracking/model/Location.dart';
import 'package:corona_tracking/model/Patient.dart';
import 'package:corona_tracking/model/UISettings.dart';
import 'package:corona_tracking/redux/Actions/UISettingsActions.dart';
import 'package:corona_tracking/redux/Actions/MessageActions.dart';
import 'package:corona_tracking/redux/AppState.dart';
import 'package:corona_tracking/redux/Middleware/criticalMeetingsMiddleware.dart';
import 'package:corona_tracking/redux/Middleware/messageMiddleware.dart';
import 'package:corona_tracking/redux/Middleware/uiSettingsMiddleware.dart';
import 'package:corona_tracking/screens/onboarding_screen.dart';
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final Store<AppState> store = Store<AppState>(
    stateReducer,
    initialState: AppState(UISettings(false, false)),
    middleware: []
      ..addAll(createUISettingsMiddleware())
      ..addAll(createCriticalMeetingsMiddleware())
      ..addAll(createMessageMiddleware()),
  );

  runApp(App(store));

  // Register to receive BackgroundFetch events after app is terminated.
  // Requires {stopOnTerminate: false, enableHeadless: true}
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class App extends StatelessWidget {
  final Store<AppState> store;

  App(this.store);

  Future<dynamic> onMessage(Map<String, dynamic> message) async {
    final DAO _ldao = LocalDAO();
    final DAO _fdao = FirestoreDAOImpl();
    print('message received: $message');
    final String patientId = message['data']['patientId'] ?? message['patientId'];

    final List<Location> localLocations =
        (await _ldao.listAll(Location.COLLECTION_NAME)).map((l) => Location.fromJson(l));

    final String collection = "${Patient.COLLECTION_NAME}/$patientId/${Location.COLLECTION_NAME}";
    final List<Location> patientLocations =
        (await _fdao.listAll(collection)).map((l) => Location.fromJson(l));

    final MeetingDetector riskCalculator = MeetingDetector(localLocations, patientLocations);

    final List<CriticalMeeting> criticalPoints = riskCalculator.criticalPoints();
    if (criticalPoints.isNotEmpty) {
      final note = Notificator();
      await note.showNotification(
          'Gefahr erkannt', 'In ihrem Bewegungsprofil gibt es Überscheidungen mit Corona-Patienten');
    }
  }

  @override
  Widget build(BuildContext context) {
    Notificator().init();
    //configurator.subscribe("infections");
    store.dispatch(InitializeUISettingsAction());
    store.dispatch(ConfigureMessageHandlerAction(onMessage: this.onMessage));
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
