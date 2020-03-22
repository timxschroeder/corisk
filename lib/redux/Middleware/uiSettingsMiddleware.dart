import 'package:corona_tracking/database/DAO.dart';
import 'package:corona_tracking/database/FirestoreDAO.dart';
import 'package:corona_tracking/database/LocalDAO.dart';
import 'package:corona_tracking/model/Location.dart';
import 'package:corona_tracking/model/Patient.dart';
import 'package:corona_tracking/model/UISettings.dart';
import 'package:corona_tracking/redux/Actions/UISettingsActions.dart';
import 'package:corona_tracking/redux/AppState.dart';
import 'package:corona_tracking/redux/Selectors/Selectors.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createUISettingsMiddleware() {
  return [
    TypedMiddleware<AppState, InitializeUISettingsAction>(_initializeUISettings),
    TypedMiddleware<AppState, SetUISettingFirstVisitAction>(_setFirstVisitUISetting),
    TypedMiddleware<AppState, SubmitInfectionAction>(_setInfectionSubmittedUISetting),
  ];
}

Middleware<AppState> _initializeUISettings = (store, action, next) async {
  final DAO dao = LocalDAO();

  UISettings currentUISettings = uiSettingsSelector(store.state);
  List<Map<String, dynamic>> savedUISettings = await dao.listAll(UISettings.COLLECTION_NAME);

  if (savedUISettings.isEmpty) {
    await dao.insert(serializable: currentUISettings);
  } else {
    currentUISettings = UISettings.fromJson(savedUISettings.first);
  }

  store.dispatch(SetUISettingFirstVisitActionSuccessful(currentUISettings));
};

Middleware<AppState> _setFirstVisitUISetting = (store, action, next) async {
  final DAO dao = LocalDAO();

  UISettings currentUISettings = uiSettingsSelector(store.state);

  currentUISettings.firstAppStart = action.isFirstVisit;

  await dao.insert(serializable: currentUISettings);

  store.dispatch(SetUISettingFirstVisitActionSuccessful(currentUISettings));
};

Middleware<AppState> _setInfectionSubmittedUISetting = (store, action, next) async {
  final DAO localDao = LocalDAO();
  final FirestoreDAOImpl firebaseDao = FirestoreDAOImpl();
  final List<Location> locations = [];
  final UISettings currentUISettings = uiSettingsSelector(store.state);

  List<Map<String, dynamic>> jsons = await localDao.listAll(Location.COLLECTION_NAME);
  jsons.forEach((l) => locations.add(Location.fromJson(l)));

  firebaseDao.insertObjectWithSubcollection(Patient(), locations);

  currentUISettings.infectionDataSubmitted = true;

  await localDao.insert(serializable: currentUISettings);

  store.dispatch(SetUISettingFirstVisitActionSuccessful(currentUISettings));
};
