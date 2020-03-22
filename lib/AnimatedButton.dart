import 'package:corona_tracking/redux/ViewModels/UISettingsViewModel.dart';
import 'package:corona_tracking/screens/tracking_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'redux/AppState.dart';

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
    InheritedDataProvider.of(context).buttonState.changeToTrue();
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    return StoreConnector<AppState, UISettingsViewModel>(
        converter: (Store<AppState> store) => UISettingsViewModel.from(store),
        builder: (context, UISettingsViewModel uiSettingsViewModel) {
          return GestureDetector(
            onTap: () => uiSettingsViewModel.onClickInfectionLevelButton(),
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
        height: 100,
        width: 250,
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
              Color(0xFFA7BFE8),
              Color(0xFF6190E8),
            ],
          ),
        ),
        child: Center(
            child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: Image(
            image: AssetImage('assets/images/destination.png'),
            fit: BoxFit.scaleDown,
          ),
        )),
      );
}
