import 'package:corona_tracking/redux/ViewModels/UISettingsViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../redux/AppState.dart';

class AnimatedButton extends StatefulWidget {
  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  double _scale;
  AnimationController _controller;

  _AnimatedButtonState();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _showConfirmation(bool successful) {
    showDialog(
        context: context,
        builder: (_) {
          return successful
              ? AlertDialog(
                  backgroundColor: Color(0xFFD6E9F8),
                  title: Text("Hochladen abgeschlossen"),
                  content: Text(
                      "Vielen Dank für das Teilen deiner Infektion. Wir werden umgehend die Betroffenen informieren."),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    FlatButton(
                      child: Text("Ok"),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              : AlertDialog(
                  backgroundColor: Color(0xFFD6E9F8),
                  title: Text("Hochladen abgebrochen"),
                  content: Text(
                      "Du hast Dich bereits als infiziert gemeldet und Deine Daten übermittelt. Vielen Dank für deine Mithilfe."),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    FlatButton(
                      child: Text("Ok"),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
        });
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    return StoreConnector<AppState, UISettingsViewModel>(
        converter: (Store<AppState> store) => UISettingsViewModel.from(store),
        builder: (context, UISettingsViewModel uiSettingsViewModel) {
          return GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      backgroundColor: Color(0xFFD6E9F8),
                      title: Text("Infizierung melden"),
                      content: Text(
                          "Möchtest du deine Infizierung melden, um Kontaktpersonen der letzten zwei Wochen zu warnen?"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Abbrechen"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                            child: Text("Ja"),
                            onPressed: () {
                              if (!uiSettingsViewModel.uiSettings.infectionDataSubmitted) {
                                uiSettingsViewModel.onSubmitInfectionData();
                              }
                              _showConfirmation(!uiSettingsViewModel.uiSettings.infectionDataSubmitted);
                            }),
                      ],
                    );
                  });
            },
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            child: Transform.scale(
              scale: _scale,
              child: StoreConnector<AppState, UISettingsViewModel>(
                  converter: (Store<AppState> store) => UISettingsViewModel.from(store),
                  builder: (context, UISettingsViewModel uiSettingsViewModel) {
                    return _animatedButtonUI;
                  }),
            ),
          );
        });
  }

  Widget get _animatedButtonUI => Container(
        height: 60,
        width: 60 * 2.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Color(0x80000000),
              blurRadius: 30.0,
              offset: Offset(0.0, 30.0),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFB53737),
              Color(0xFF9E1A1A),
            ],
          ),
        ),
        child: Center(
            child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: Image(
            image: AssetImage('assets/images/virus.png'),
            fit: BoxFit.scaleDown,
          ),
        )),
      );
}
