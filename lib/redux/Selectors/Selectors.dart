import 'package:corona_tracking/model/UISettings.dart';
import 'package:corona_tracking/redux/AppState.dart';

UISettings uiSettingsSelector(AppState state) => state.uiSettings;
