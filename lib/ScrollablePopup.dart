import 'package:corona_tracking/redux/AppState.dart';
import 'package:corona_tracking/redux/ViewModels/UISettingsViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CustomPopup extends StatefulWidget {
  CustomPopup({
    @required this.items,
    @required this.builderFunction,
  });

  final List<dynamic> items;
  final Function(BuildContext context, dynamic item) builderFunction;

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
              alignment: Alignment.center,
              children: [
                //in the background to close the screen again
                InkWell(onTap: () => uiSettingsViewModel.onDismissInfectionLevel()),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: uiSettingsViewModel.uiSettings.infectionLevelButtonClicked
                      ? MediaQuery.of(context).size.height / 2
                      : 0,
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: Card(
                    elevation: 3,
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          Widget item = widget.builderFunction(
                            context,
                            widget.items[index],
                          );
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
