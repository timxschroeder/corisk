import 'package:corona_tracking/model/CriticalMeeting.dart';
import 'package:corona_tracking/redux/AppState.dart';
import 'package:corona_tracking/redux/ViewModels/UISettingsViewModel.dart';
import 'package:corona_tracking/utilities/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geocoder/geocoder.dart';
import 'package:redux/redux.dart';

class CustomPopup extends StatefulWidget {
  CustomPopup({
    @required this.criticalMeetings,
  });

  final List<CriticalMeeting> criticalMeetings;

  @override
  _CustomPopupState createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UISettingsViewModel>(
        converter: (Store<AppState> store) => UISettingsViewModel.from(store),
        builder: (context, UISettingsViewModel uiSettingsViewModel) {
          return Offstage(
            offstage: !uiSettingsViewModel.uiSettings.infectionLevelButtonClicked,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                //in the background to close the screen again
                InkWell(onTap: () => uiSettingsViewModel.onDismissInfectionLevel()),
                Positioned(
                  top: 100.0,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: uiSettingsViewModel.uiSettings.infectionLevelButtonClicked
                        ? MediaQuery.of(context).size.height / 1.5
                        : 0,
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Card(
                      color: Color(0xFFD6E9F8),
                      elevation: 3,
                      child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        itemCount: widget.criticalMeetings.length + 1,
                        separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                        itemBuilder: (context, index) {
                          Widget item = index == 0
                              ? Center(
                                  child: Text(
                                  "Deine Kontakte zu Infizierten:",
                                  style: kSmallTitleStyle,
                                ))
                              : CriticalMeetingListTile(widget.criticalMeetings[index - 1]);
                          return item;
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class CriticalMeetingListTile extends StatelessWidget {
  final CriticalMeeting criticalMeeting;
  final Coordinates coordinates;

  CriticalMeetingListTile(this.criticalMeeting)
      : this.coordinates = Coordinates(
            criticalMeeting.location.position.latitude, criticalMeeting.location.position.longitude);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(extractTimeString(criticalMeeting.location.position.timestamp)),
      subtitle: FutureBuilder(
        future: extractAddress(),
        initialData: " ",
        builder: (BuildContext context, AsyncSnapshot<String> text) {
          return Text(text.data);
        },
      ),
    );
  }

  Future<String> extractAddress() async {
    List<Address> addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    //found addresses may be empty
    String addressText = addresses.first.addressLine ?? coordinates.toString();
    return addressText;
  }

  String extractTimeString(DateTime dateTime) {
    String text =
        dateTime.day.toString() + "." + dateTime.month.toString() + "." + dateTime.year.toString() + " ";
    text += dateTime.hour.toString() + ":" + dateTime.hour.toString() + " Uhr";

    return text;
  }
}
