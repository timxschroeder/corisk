import 'package:corona_tracking/AnimatedButton.dart';
import 'package:corona_tracking/DAO.dart';
import 'package:corona_tracking/FirestoreDAO.dart';
import 'package:corona_tracking/LocationDAO.dart';
import 'package:corona_tracking/ScrollablePopup.dart';
import 'package:corona_tracking/model/Location.dart';
import 'package:corona_tracking/model/Patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TrackingUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("building gradient");
    return InheritedDataProvider(
      buttonState: ButtonState(false),
      child: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
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

class InheritedDataProvider extends InheritedWidget {
  final ButtonState buttonState;

  InheritedDataProvider({
    Widget child,
    this.buttonState,
  }) : super(child: child);

  @override
  bool updateShouldNotify(InheritedDataProvider oldWidget) {
    print("notify");
    return buttonState != oldWidget.buttonState;
  }

  static InheritedDataProvider of(BuildContext context) => context.dependOnInheritedWidgetOfExactType();
}

class ButtonState {
  bool shouldShow;

  ButtonState(this.shouldShow);

  void changeToTrue() {
    shouldShow = true;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ButtonState && runtimeType == other.runtimeType && shouldShow == other.shouldShow;

  @override
  int get hashCode => shouldShow.hashCode;
}
