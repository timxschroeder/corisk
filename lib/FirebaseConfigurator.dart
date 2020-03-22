import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseConfigurator {
  final FirebaseMessaging _messaging = FirebaseMessaging();

  static final FirebaseConfigurator _instance =
      FirebaseConfigurator._internal();

  factory FirebaseConfigurator() => _instance;

  FirebaseConfigurator._internal();

  void subscribe(String topic) {
    _messaging.subscribeToTopic(topic);
  }

  void configure(MessageHandler onMessage) {
    _messaging.configure(
      onMessage: onMessage,
    );
  }
}
