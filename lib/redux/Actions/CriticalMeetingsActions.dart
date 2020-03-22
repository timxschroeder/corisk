
import 'package:corona_tracking/model/CriticalMeeting.dart';

class AddCriticalMeetingsAction {
  List<CriticalMeeting> meetingsToAdd;

  AddCriticalMeetingsAction(this.meetingsToAdd);
}

class LoadCriticalMeetingsAction {
}

class LoadCriticalMeetingsSuccessfulAction {
  List<CriticalMeeting> meetings;

  LoadCriticalMeetingsSuccessfulAction(this.meetings);
}

