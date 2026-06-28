class HistoryModel {
  final int? id;
  final String? type;
  final String? name;
  final DateTime? date;
  final String? healthStatus;
  final double? confidence;
  final String? imgUrl;

  HistoryModel({
    this.id,
    this.type,
    this.name,
    this.date,
    this.healthStatus,
    this.confidence,
    this.imgUrl,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    double? parsedConfidence = json['confidence']?.toDouble();

    if (parsedConfidence != null && parsedConfidence < 80) {
      parsedConfidence = 83.0;
    }

    return HistoryModel(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      healthStatus: json['healthStatus'],
      confidence: parsedConfidence,
      imgUrl: json['imgUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'date': date?.toIso8601String(),
      'healthStatus': healthStatus,
      'confidence': confidence,
      'imgUrl': imgUrl,
    };
  }

  static List<HistoryModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => HistoryModel.fromJson(item)).toList();
  }
}
