import 'package:corona_tracking/Serializable.dart';

class UISettings extends Serializable {
  /// for DAO-Call
  static const String COLLECTION_NAME = "UISettings";

  /// for DAO-intern
  @override
  String get collectionName => COLLECTION_NAME;

  bool firstAppStart;

  bool infectionLevelButtonClicked;

  bool infectionDataSubmitted;

  UISettings(this.firstAppStart, this.infectionLevelButtonClicked, this.infectionDataSubmitted);

  UISettings.fromJson(Map<String, dynamic> json)
      : this.firstAppStart = json['firstAppStart'],
        this.infectionLevelButtonClicked =
            false, //should always be false on initialization due to UI functionality
        this.infectionDataSubmitted = json['locationDataSubmitted'],
        super() {
    this.id = json['id'];
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'firstAppStart': firstAppStart,
        'locationDataSubmitted': infectionDataSubmitted,
      };
}
