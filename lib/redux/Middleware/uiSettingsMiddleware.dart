import 'package:corona_tracking/DAO.dart';
import 'package:corona_tracking/LocalDAO.dart';
import 'package:corona_tracking/model/UISettings.dart';
import 'package:corona_tracking/redux/Actions/UISettingsActions.dart';
import 'package:corona_tracking/redux/AppState.dart';
import 'package:corona_tracking/redux/Selectors/Selectors.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createUISettingsMiddleware() {
  return [
    TypedMiddleware<AppState, InitializeUISettingsAction>(_initializeUISettings),
    TypedMiddleware<AppState, SetUISettingFirstVisitAction>(_setFirstVisitUISetting),
  ];
}

Middleware<AppState> _initializeUISettings = (store, action, next) async {
  final DAO dao = LocalDAO();

  UISettings currentUISettings = uiSettingsSelector(store.state);
  List<Map<String, dynamic>> savedUISettings = await dao.listAll(UISettings.COLLECTION_NAME);

  if (savedUISettings.isEmpty) {
    await dao.insert(serializable: currentUISettings);
  } else {
    currentUISettings.firstAppStart = UISettings.fromJson(savedUISettings.first).firstAppStart;
  }

  store.dispatch(SetUISettingFirstVisitActionSuccessful(currentUISettings.firstAppStart));
};

Middleware<AppState> _setFirstVisitUISetting = (store, action, next) async {
  final DAO dao = LocalDAO();

  UISettings currentUISettings = uiSettingsSelector(store.state);

  currentUISettings.firstAppStart = action.isFirstVisit;

  await dao.insert(serializable: currentUISettings);

  store.dispatch(SetUISettingFirstVisitActionSuccessful(currentUISettings.firstAppStart));
};
