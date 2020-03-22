import 'package:corona_tracking/model/CriticalMeeting.dart';

class RiskCalculator {
  /// simple formula
  double risk(CriticalMeeting meeting){
    return (5 - meeting.distance) * 3;
  }

}