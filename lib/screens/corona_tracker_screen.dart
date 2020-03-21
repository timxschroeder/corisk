import 'package:background_fetch/background_fetch.dart';
import 'package:corona_tracking/DAO.dart';
import 'package:corona_tracking/FirestoreDAO.dart';
import 'package:corona_tracking/LocationDAO.dart';
import 'package:corona_tracking/model/Location.dart';
import 'package:corona_tracking/model/Patient.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CoronaRiskTracker extends StatefulWidget {
  @override
  _CoronaRiskTrackerState createState() => new _CoronaRiskTrackerState();
}

class _CoronaRiskTrackerState extends State<CoronaRiskTracker> {
  bool _enabled = true;
  int _status = 0;
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
      setState(() {
        _status = status;
      });
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
      setState(() {
        _status = e;
      });
    });

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
    print("Logic starts here");

    var geolocator = Geolocator();
    Location loc = new Location(await geolocator.getCurrentPosition());
    print(loc);

    _insertLocationIntoDatabase(loc);

    setState(() {
      _events.insert(0, "$taskId@${timestamp.toString()}");
    });

    // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
    // for taking too long in the background.
    BackgroundFetch.finish(taskId);
  }

  void _onClickEnable(enabled) {
    setState(() {
      _enabled = enabled;
    });
    if (enabled) {
      BackgroundFetch.start().then((int status) {
        print('[BackgroundFetch] start success: $status');
      }).catchError((e) {
        print('[BackgroundFetch] start FAILURE: $e');
      });
    } else {
      BackgroundFetch.stop().then((int status) {
        print('[BackgroundFetch] stop success: $status');
      });
    }
  }

  void _onClickStatus() async {
    int status = await BackgroundFetch.status;
    print('[BackgroundFetch] status: $status');
    setState(() {
      _status = status;
    });
  }

  void _onClickClear() async {
    setState(() {
      _events = [];
    });
  }

  Future<void> _calculateDanger(Map<String, dynamic> message) async {
    return;
  }

  @override
  Widget build(BuildContext context) {
    const EMPTY_TEXT = Center(
        child: Text(
            'Waiting for fetch events.  Simulate one.\n [Android] \$ ./scripts/simulate-fetch\n [iOS] XCode->Debug->Simulate Background Fetch'));
    FirebaseMessaging().subscribeToTopic("all");
    FirebaseMessaging().configure(
      onMessage: _calculateDanger,
    );

    return Scaffold(
      appBar: AppBar(
          title: const Text('Corisk', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.green,
          brightness: Brightness.light,
          actions: <Widget>[
            Switch(value: _enabled, onChanged: _onClickEnable),
          ]),
      body: (_events.isEmpty)
          ? EMPTY_TEXT
          : Container(
              child: new ListView.builder(
                  itemCount: _events.length,
                  itemBuilder: (BuildContext context, int index) {
                    List<String> event = _events[index].split("@");
                    return InputDecorator(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
                            labelStyle: TextStyle(color: Colors.blue, fontSize: 20.0),
                            labelText: "[${event[0].toString()}]"),
                        child: new Text(event[1], style: TextStyle(color: Colors.black, fontSize: 16.0)));
                  }),
            ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.only(left: 5.0, right: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton(onPressed: _onClickStatus, child: Text('Status: $_status')),
              RaisedButton(onPressed: _onClickClear, child: Text('Clear')),
              RaisedButton(
                  onPressed: () async {
                    DAO locationDao = LocationDAO();
                    FirestoreDAOImpl firebaseDao = FirestoreDAOImpl();
                    List<Map<String, dynamic>> jsons = await locationDao.listAll(Location.COLLECTION_NAME);
                    List<Location> locations = [];
                    jsons.forEach((l) => locations.add(Location.fromJson(l)));
                    firebaseDao.insertObjectWithSubcollection(Patient(), locations);
                  },
                  child: Text('Insert')),
              RaisedButton(
                  onPressed: () async {
                    final String collectionPath = "Patient/3b84546b-3b84-4ff9-afdb-19c95a999d4a/Location";
                    FirestoreDAOImpl firebaseDao = FirestoreDAOImpl();
                    List<Map<String, dynamic>> jsons = await firebaseDao.listAll(collectionPath);
                    List<Location> locations = [];
                    jsons.forEach((l) => locations.add(Location.fromJson(l)));

                    print("ACHTUNGG!!!!!");
                    print(locations.toString());
                  },
                  child: Text('Get')),
            ],
          ),
        ),
      ),
    );
  }

  void _insertLocationIntoDatabase(Location loc) async {
    DAO dao = LocationDAO();

    dao.insert(serializable: loc);
  }
}
