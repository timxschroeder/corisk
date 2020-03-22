import 'dart:core';

import 'package:corona_tracking/database/FirebaseConfigurator.dart';
import 'package:corona_tracking/redux/Actions/MessageActions.dart';
import 'package:corona_tracking/redux/AppState.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createMessageMiddleware() {
  return [
    TypedMiddleware<AppState, ConfigureMessageHandlerAction>(_configureMessageHandler),
    TypedMiddleware<AppState, UpdateDeviceMessagingTokenAction>(_updateDeviceMessagingToken),
  ];
}

Middleware<AppState> _configureMessageHandler = (store, action, next) {
  final FirebaseConfigurator _messageService = FirebaseConfigurator();
  _messageService.subscribe(action.topic);
  _messageService.configure(
    action.onMessage,
  );
};

Middleware<AppState> _updateDeviceMessagingToken = (store, action, next) {
  final FirebaseConfigurator _messageService = FirebaseConfigurator();
  _messageService.getFirebaseMessagingToken().then((token) => print("messaging token is: $token"));
};
