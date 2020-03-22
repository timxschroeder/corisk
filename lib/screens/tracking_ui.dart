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
            Center(child: RiskIndicator())
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
                  FlatButton(
                    child: Text("Ja"),
                    onPressed: () {
                      /// TODO Infizierung melden
                    },
                  ),
                ],
              );
            }),
        child: Icon(Icons.add),
      ),
    );
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
      progressColor: HSVColor.lerp(HSVColor.fromColor(Color(0xffffd56a)), HSVColor.fromColor(Color(0xffe45314)), percent).toColor(),
      backgroundColor: Colors.white70,
    );
  }
}
