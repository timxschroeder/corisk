import 'dart:core';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';

abstract class MessageAction {}

class ConfigureMessageHandlerAction extends MessageAction {
  final MessageHandler onMessage;
  final String topic;

  ConfigureMessageHandlerAction({
    @required this.topic,
    @required this.onMessage,
  });
}

class UpdateDeviceMessagingTokenAction extends MessageAction {}

