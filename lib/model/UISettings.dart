import 'package:corona_tracking/Serializable.dart';

class UISettings extends Serializable {
  /// for DAO-Call
  static const String COLLECTION_NAME = "UISettings";

  /// for DAO-intern
  @override
  String get collectionName => COLLECTION_NAME;

  bool firstAppStart;

  bool infectionLevelButtonClicked;

  UISettings(this.firstAppStart, this.infectionLevelButtonClicked);

  UISettings.fromJson(Map<String, dynamic> json)
      : this.firstAppStart = json['firstAppStart'],
        this.infectionLevelButtonClicked =
            false, //should always be false on initialization due to UI functionality
        super() {
    this.id = json['id'];
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'firstAppStart': firstAppStart,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UISettings &&
          runtimeType == other.runtimeType &&
          firstAppStart == other.firstAppStart &&
          infectionLevelButtonClicked == other.infectionLevelButtonClicked;

  @override
  int get hashCode => firstAppStart.hashCode ^ infectionLevelButtonClicked.hashCode;
}
