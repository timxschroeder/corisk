import 'package:background_fetch/background_fetch.dart';
import 'package:corona_tracking/database/DAO.dart';
import 'package:corona_tracking/database/LocalDAO.dart';
import 'package:corona_tracking/model/Location.dart';
import 'package:corona_tracking/screens/TrackingUi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';

class CoronaRiskTracker extends StatefulWidget {
  @override
  _CoronaRiskTrackerState createState() => new _CoronaRiskTrackerState();
}

class _CoronaRiskTrackerState extends State<CoronaRiskTracker> {
  List<String> _events = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    BackgroundFetch.configure(
            BackgroundFetchConfig(
              minimumFetchInterval: 15,
              forceAlarmManager: false,
              stopOnTerminate: false,
              startOnBoot: true,
              enableHeadless: true,
              requiresBatteryNotLow: false,
              requiresCharging: false,
              requiresStorageNotLow: false,
              requiresDeviceIdle: false,
              requiredNetworkType: NetworkType.NONE,
            ),
            _onBackgroundFetch)
        .then((int status) {
      print('[BackgroundFetch] configure success: $status');
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
    });

    // run once to get Location
    _onBackgroundFetch("de.fortysevenapp.coronatracking.location.update");

    BackgroundFetch.scheduleTask(
      TaskConfig(
        taskId: "de.fortysevenapp.coronatracking.location.update",
        delay: 1000,
        periodic: true,
        forceAlarmManager: true,
        stopOnTerminate: false,
        enableHeadless: true,
      ),
    );

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  void _onBackgroundFetch(String taskId) async {
    DateTime timestamp = new DateTime.now();
    // This is the fetch-event callback.
    print("$timestamp [BackgroundFetch] Event received: $taskId");

    try {
      var geolocator = Geolocator();
      Location loc = new Location(await geolocator.getCurrentPosition());
      _insertLocationIntoDatabase(loc);
    } on PlatformException {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return PermissionAlert();
          });
    }

    setState(() {
      _events.insert(0, "$taskId@${timestamp.toString()}");
    });

    // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
    // for taking too long in the background.
    BackgroundFetch.finish(taskId);
  }

  @override
  Widget build(BuildContext context) {
    return TrackingUI();
  }

  void _insertLocationIntoDatabase(Location loc) async {
    DAO dao = LocalDAO();

    dao.insert(serializable: loc);
  }
}

class PermissionAlert extends StatelessWidget {
  const PermissionAlert({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EmojiParser parser = EmojiParser();
    return AlertDialog(
      title: Text("Achtung!"),
      content: Text(parser.emojify(
          "Ohne deine Zustimmung, auf den Standort zuzugreifen, kann die App leider nicht funktionieren. :white_frowning_face:")),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        FlatButton(
          child: Text("Beenden"),
          onPressed: () {
            SystemNavigator.pop();
          },
        ),
        FlatButton(
          child: Text("Alles klar"),
          onPressed: () async {
            PermissionStatus permission = await LocationPermissions().requestPermissions();
            print(permission);
            if (permission != PermissionStatus.granted) {
              print("Öffne App Settings..");
              await LocationPermissions().openAppSettings();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
