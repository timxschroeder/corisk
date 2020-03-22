import 'package:corona_tracking/model/CriticalMeeting.dart';
import 'package:corona_tracking/model/UISettings.dart';
import 'package:corona_tracking/redux/Reducer/criticalMeetingsReducer.dart';
import 'package:corona_tracking/redux/Reducer/uiSettingsReducer.dart';
import 'package:corona_tracking/redux/Selectors/Selectors.dart';

/// Global AppState, which holds all information relevant to building UI and Persistence.
///
/// @see {lib/redux/documentation.md}
class AppState {
  UISettings uiSettings;

  List<CriticalMeeting> criticalMeetings;

  AppState();

  factory AppState.initialState() {
    return AppState()
      ..uiSettings = UISettings(true, false, false)
      ..criticalMeetings = [];
  }
}

AppState stateReducer(AppState state, action) {
  state.uiSettings = uiSettingsReducer(uiSettingsSelector(state), action);
  state.criticalMeetings = criticalMeetingsReducer(criticalMeetingsSelector(state), action);

  return state;
}
