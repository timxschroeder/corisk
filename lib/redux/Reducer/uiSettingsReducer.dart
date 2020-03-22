import 'package:corona_tracking/model/UISettings.dart';
import 'package:corona_tracking/redux/Actions/UISettingsActions.dart';
import 'package:redux/redux.dart';

final uiSettingsReducer = combineReducers<UISettings>([
  TypedReducer<UISettings, SetUISettingFirstVisitActionSuccessful>(_updateUISetting),
  TypedReducer<UISettings, ClickInfectionLevelButtonAction>(_updateUISetting),
  TypedReducer<UISettings, DismissInfectionLevelAction>(_updateUISetting),
  TypedReducer<UISettings, SubmitInfectionSuccessfulAction>(_updateUISetting),
]);

UISettings _updateUISetting(UISettings uiSettings, UISettingsAction action) {
  if (action is SetUISettingFirstVisitActionSuccessful) {
    uiSettings = action.uiSettings;
  } else if (action is ClickInfectionLevelButtonAction) {
    uiSettings.infectionLevelButtonClicked = true;
  } else if (action is DismissInfectionLevelAction) {
    uiSettings.infectionLevelButtonClicked = false;
  } else if (action is SubmitInfectionSuccessfulAction) {
    uiSettings.infectionDataSubmitted = true;
  }

  return uiSettings;
}
