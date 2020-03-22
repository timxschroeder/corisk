import 'package:background_fetch/background_fetch.dart';
import 'package:corona_tracking/FirebaseConfigurator.dart';
import 'package:corona_tracking/model/UISettings.dart';
import 'package:corona_tracking/redux/Actions/UISettingsActions.dart';
import 'package:corona_tracking/redux/AppState.dart';
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
  FirebaseConfigurator();
  runApp(App());

  // Register to receive BackgroundFetch events after app is terminated.
  // Requires {stopOnTerminate: false, enableHeadless: true}
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class App extends StatelessWidget {
  final Store<AppState> store = Store<AppState>(
    stateReducer,
    initialState: AppState(UISettings(true, false)),
    middleware: []..addAll(createUISettingsMiddleware()),
  );

  @override
  Widget build(BuildContext context) {
    store.dispatch(InitializeUISettingsAction());

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
