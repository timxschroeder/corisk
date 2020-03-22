import 'package:corona_tracking/model/CriticalMeeting.dart';
import 'package:corona_tracking/redux/AppState.dart';
import 'package:corona_tracking/redux/Selectors/Selectors.dart';
import 'package:corona_tracking/redux/ViewModels/ViewModel.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

class CriticalMeetingsViewModel extends ViewModel {
  final List<CriticalMeeting> meetings;

  CriticalMeetingsViewModel({
    @required this.meetings,
  });

  factory CriticalMeetingsViewModel.from(Store<AppState> store) {
    return CriticalMeetingsViewModel(
      meetings: criticalMeetingsSelector(store.state),
    );
  }
}
