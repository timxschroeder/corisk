abstract class UISettingsAction {}

class InitializeUISettingsAction extends UISettingsAction {
  InitializeUISettingsAction();
}

class SetUISettingFirstVisitAction extends UISettingsAction {
  final bool isFirstVisit;

  SetUISettingFirstVisitAction(this.isFirstVisit);
}

class SetUISettingFirstVisitActionSuccessful extends UISettingsAction {
  final bool isFirstVisit;

  SetUISettingFirstVisitActionSuccessful(this.isFirstVisit);
}

class ClickInfectionLevelButtonAction extends UISettingsAction {}

class DismissInfectionLevelAction extends UISettingsAction {}
