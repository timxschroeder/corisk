import 'package:corona_tracking/model/UISettings.dart';

abstract class UISettingsAction {}

class InitializeUISettingsAction extends UISettingsAction {
  InitializeUISettingsAction();
}

class SetUISettingFirstVisitAction extends UISettingsAction {
  final bool isFirstVisit;

  SetUISettingFirstVisitAction(this.isFirstVisit);
}

class SetUISettingFirstVisitActionSuccessful extends UISettingsAction {
  final UISettings uiSettings;

  SetUISettingFirstVisitActionSuccessful(this.uiSettings);
}

class ClickInfectionLevelButtonAction extends UISettingsAction {}

class DismissInfectionLevelAction extends UISettingsAction {}

class SubmitInfectionAction extends UISettingsAction {}

class SubmitInfectionSuccessfulAction extends UISettingsAction {}
