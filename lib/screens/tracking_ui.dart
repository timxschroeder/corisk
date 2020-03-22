import 'package:corona_tracking/AnimatedButton.dart';
import 'package:corona_tracking/ScrollablePopup.dart';
import 'package:corona_tracking/model/CriticalMeeting.dart';
import 'package:corona_tracking/model/Location.dart';
import 'package:corona_tracking/redux/AppState.dart';
import 'package:corona_tracking/redux/ViewModels/CriticalMeetingsViewModel.dart';
import 'package:corona_tracking/redux/ViewModels/UISettingsViewModel.dart';
import 'package:corona_tracking/utilities/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:redux/redux.dart';

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
              //Positioned(child: AnimatedButton(), top: 200.0),

              MeetingPopUp(),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AnimatedButton());
  }
}

class MeetingPopUp extends StatelessWidget {
  const MeetingPopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CriticalMeetingsViewModel>(
      converter: (Store<AppState> store) => CriticalMeetingsViewModel.from(store),
      builder: (context, CriticalMeetingsViewModel viewModel) {
        return CustomPopup(
          criticalMeetings: viewModel.meetings,
          builderFunction: (context, item) {
            return ListTile(title: Text(item.toString()), onTap: () {});
          },
        );
      },
    );
  }
}

class RiskIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double percent = 0.1;
    return StoreConnector<AppState, UISettingsViewModel>(
      converter: (Store<AppState> store) => UISettingsViewModel.from(store),
      builder: (context, UISettingsViewModel uiSettingsViewModel) {
        return InkWell(
          onTap: () => uiSettingsViewModel.onClickInfectionLevelButton(),
          child: CircularPercentIndicator(
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
            progressColor: HSVColor.lerp(
                    HSVColor.fromColor(Color(0xffffd56a)), HSVColor.fromColor(Color(0xffe45314)), percent)
                .toColor(),
            backgroundColor: Colors.white70,
          ),
        );
      },
    );
  }
}
