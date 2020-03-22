import 'package:corona_tracking/model/CriticalMeeting.dart';
import 'package:corona_tracking/redux/Actions/CriticalMeetingsActions.dart';
import 'package:redux/redux.dart';

final criticalMeetingsReducer = combineReducers<List<CriticalMeeting>>([
  TypedReducer<List<CriticalMeeting>, LoadCriticalMeetingsSuccessfulAction>(_updateCriticalMeetings),
]);

List<CriticalMeeting> _updateCriticalMeetings(List<CriticalMeeting> state, LoadCriticalMeetingsSuccessfulAction action) {
  return action.meetings;
}
