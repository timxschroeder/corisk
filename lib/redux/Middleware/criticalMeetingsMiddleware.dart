import 'package:corona_tracking/DAO.dart';
import 'package:corona_tracking/LocalDAO.dart';
import 'package:corona_tracking/model/CriticalMeeting.dart';
import 'package:corona_tracking/model/UISettings.dart';
import 'package:corona_tracking/redux/Actions/CriticalMeetingsActions.dart';
import 'package:corona_tracking/redux/Actions/UISettingsActions.dart';
import 'package:corona_tracking/redux/AppState.dart';
import 'package:corona_tracking/redux/Selectors/Selectors.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createCriticalMeetingsMiddleware() {
  return [
    TypedMiddleware<AppState, LoadCriticalMeetingsAction>(_loadCriticalMeetings),
    TypedMiddleware<AppState, AddCriticalMeetingsAction>(_addCriticalMeetings),
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


Middleware<AppState> _loadCriticalMeetings= (store, action,  next) async{
  final DAO dao = LocalDAO();
  List<CriticalMeeting> meetings = await dao.listAll(CriticalMeeting.COLLECTION_NAME).then((jsons){
    return jsons.map((json) => CriticalMeeting.fromJson(json));
  }).catchError((err){
    print(err);
  });
  store.dispatch(LoadCriticalMeetingsSuccessfulAction(meetings));
};

Middleware<AppState> _addCriticalMeetings = (store,  action,  next) async {
  final DAO dao = LocalDAO();
  for (CriticalMeeting meeting in action.meetings){
    await dao.insert(serializable: meeting);
  }
  store.dispatch(LoadCriticalMeetingsAction());
};
