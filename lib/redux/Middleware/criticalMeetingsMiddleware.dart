import 'package:corona_tracking/database/DAO.dart';
import 'package:corona_tracking/database/LocalDAO.dart';
import 'package:corona_tracking/model/CriticalMeeting.dart';
import 'package:corona_tracking/redux/Actions/CriticalMeetingsActions.dart';
import 'package:corona_tracking/redux/AppState.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createCriticalMeetingsMiddleware() {
  return [
    TypedMiddleware<AppState, LoadCriticalMeetingsAction>(_loadCriticalMeetings),
    TypedMiddleware<AppState, AddCriticalMeetingsAction>(_addCriticalMeetings),
  ];
}

Middleware<AppState> _loadCriticalMeetings = (store, action, next) async {
  final DAO dao = LocalDAO();
  List<CriticalMeeting> meetings = await dao.listAll(CriticalMeeting.COLLECTION_NAME).then((jsons) {
    return jsons.map((json) => CriticalMeeting.fromJson(json)).toList();
  }).catchError((err) {
    print(err);
  });
  store.dispatch(LoadCriticalMeetingsSuccessfulAction(meetings));
};

Middleware<AppState> _addCriticalMeetings = (store, action, next) async {
  final DAO dao = LocalDAO();
  for (CriticalMeeting meeting in action.meetings) {
    await dao.insert(serializable: meeting);
  }
  store.dispatch(LoadCriticalMeetingsAction());
};
