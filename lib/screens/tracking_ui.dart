import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TrackingUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("building gradient");
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.01, 0.82, 1],
              colors: [
                Color(0xFFe0dff1),
                Color(0xFF145791),
                Color(0xFF0652a4),
               // Color(0xe0dff1),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.red,onPressed: () => showDialog(context: context, builder: (_){
        return AlertDialog(
          title: Text("Infizierung melden"),
          content: Text("Möchtest du deine Infizierung melden, um Kontaktpersonen der letzten zwei Wochen zu warnen?"),
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
      }), child: Icon(Icons.add),),
    );
  }
}
