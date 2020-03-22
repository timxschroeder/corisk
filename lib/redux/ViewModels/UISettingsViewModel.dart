import 'package:corona_tracking/model/UISettings.dart';
import 'package:corona_tracking/redux/Actions/UISettingsActions.dart';
import 'package:corona_tracking/redux/AppState.dart';
import 'package:corona_tracking/redux/Selectors/Selectors.dart';
import 'package:corona_tracking/redux/ViewModels/ViewModel.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

class UISettingsViewModel extends ViewModel {
  final Function onInitializeUISettings;
  final Function(bool) onSetFirstVisit;
  final Function onClickInfectionLevelButton;
  final Function onDismissInfectionLevel;
  final Function onSubmitInfectionData;
  final UISettings uiSettings;

  UISettingsViewModel({
    @required this.onInitializeUISettings,
    @required this.onSetFirstVisit,
    @required this.onClickInfectionLevelButton,
    @required this.onDismissInfectionLevel,
    @required this.onSubmitInfectionData,
    @required this.uiSettings,
  });

  factory UISettingsViewModel.from(Store<AppState> store) {
    final Function onInitializeUISettings = () {
      store.dispatch(InitializeUISettingsAction());
    };

    final Function onSetFirstVisit = (bool isFirstAppVisit) {
      store.dispatch(SetUISettingFirstVisitAction(isFirstAppVisit));
    };

    final Function onClickInfectionLevelButton = () {
      store.dispatch(ClickInfectionLevelButtonAction());
    };

    final Function onDismissInfectionLevel = () {
      store.dispatch(DismissInfectionLevelAction());
    };

    final Function onSubmitInfectionData = () {
      store.dispatch(SubmitInfectionAction());
    };

    return UISettingsViewModel(
      onInitializeUISettings: onInitializeUISettings,
      onSetFirstVisit: onSetFirstVisit,
      onClickInfectionLevelButton: onClickInfectionLevelButton,
      onDismissInfectionLevel: onDismissInfectionLevel,
      onSubmitInfectionData: onSubmitInfectionData,
      uiSettings: uiSettingsSelector(store.state),
    );
  }
}
