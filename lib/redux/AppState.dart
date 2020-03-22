import 'package:corona_tracking/model/UISettings.dart';
import 'package:corona_tracking/redux/Reducer/uiSettingsReducer.dart';
import 'package:corona_tracking/redux/Selectors/Selectors.dart';

/// Global AppState, which holds all information relevant to building UI and Persistence.
///
/// @see {lib/redux/documentation.md}
///
/// @author schroeder
/// @date 12.12.2018
class AppState {
  UISettings uiSettings;

  AppState(this.uiSettings);
}

AppState stateReducer(AppState state, action) {
  state.uiSettings = uiSettingsReducer(uiSettingsSelector(state), action);

  return state;
}
