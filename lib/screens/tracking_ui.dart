import 'package:corona_tracking/AnimatedButton.dart';
import 'package:corona_tracking/DAO.dart';
import 'package:corona_tracking/FirestoreDAO.dart';
import 'package:corona_tracking/LocationDAO.dart';
import 'package:corona_tracking/ScrollablePopup.dart';
import 'package:corona_tracking/model/Location.dart';
import 'package:corona_tracking/model/Patient.dart';
import 'package:corona_tracking/utilities/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TrackingUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("building gradient");
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.4, 0.7, 0.9],
                  colors: [
                    Color(0xFF3594DD),
                    Color(0xFF4563DB),
                    Color(0xFF5036D5),
                    Color(0xFF5B16D0),
                  ],
                ),
              ),
            ),
            Center(child: RiskIndicator()),
            Positioned(child: AnimatedButton(), top: 200.0),
            Center(
              child: CustomPopup(
                items: [1, 2, 3, 4, 5, 6, 7, 8],
                builderFunction: (context, item) {
                  return ListTile(title: Text(item.toString()), onTap: () {});
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () => showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text("Infizierung melden"),
                content: Text(
                    "Möchtest du deine Infizierung melden, um Kontaktpersonen der letzten zwei Wochen zu warnen?"),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  FlatButton(
                    child: Text("Abbrechen"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(child: Text("Ja"), onPressed: () async => await _uploadLocationData()),
                ],
              );
            }),
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _uploadLocationData() async {
    final DAO locationDao = LocationDAO();
    final FirestoreDAOImpl firebaseDao = FirestoreDAOImpl();
    final List<Location> locations = [];

    List<Map<String, dynamic>> jsons = await locationDao.listAll(Location.COLLECTION_NAME);

    jsons.forEach((l) => locations.add(Location.fromJson(l)));

    firebaseDao.insertObjectWithSubcollection(Patient(), locations);
  }
}

class RiskIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double percent = 0.1;
    return CircularPercentIndicator(
      radius: 300.0,
      lineWidth: 45.0,
      animation: true,
      percent: percent,
      center: Text(
        NumberFormat.percentPattern().format(percent),
        style: kTitleStyle,
      ),
      footer: Text(
        "Dein Infektionsrisiko",
        style: kTitleStyle,
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor:
          HSVColor.lerp(HSVColor.fromColor(Color(0xffffd56a)), HSVColor.fromColor(Color(0xffe45314)), percent)
              .toColor(),
      backgroundColor: Colors.white70,
    );
  }
}
