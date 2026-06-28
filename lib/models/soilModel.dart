class SoilModel {
  final PredictionData? data;
  final double? avgAirTemperature;
  final double? avgMoisture;
  final double? avgPh;
  final double? avgNitrogen;
  final double? avgPotassium;
  final double? avgPhosphorus;

  SoilModel({
    this.data,
    this.avgAirTemperature,
    this.avgMoisture,
    this.avgPh,
    this.avgNitrogen,
    this.avgPotassium,
    this.avgPhosphorus,
  });

  factory SoilModel.fromJson(Map<String, dynamic> json) {
    return SoilModel(
      data: json['data'] != null ? PredictionData.fromJson(json['data']) : null,
      avgAirTemperature: json['avgAirTemperature']?.toDouble(),
      avgMoisture: json['avgMoisture']?.toDouble(),
      avgPh: json['avgPh']?.toDouble(),
      avgNitrogen: json['avgNitrogen']?.toDouble(),
      avgPotassium: json['avgPotassium']?.toDouble(),
      avgPhosphorus: json['avgPhosphorus']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'avgAirTemperature': avgAirTemperature,
      'avgMoisture': avgMoisture,
      'avgPh': avgPh,
      'avgNitrogen': avgNitrogen,
      'avgPotassium': avgPotassium,
      'avgPhosphorus': avgPhosphorus,
    };
  }
}

class PredictionData {
  final int? id;
  final String? prediction;
  final double? confidence;
  final DateTime? createdAt;

  PredictionData({
    this.id,
    this.prediction,
    this.confidence,
    this.createdAt,
  });

  factory PredictionData.fromJson(Map<String, dynamic> json) {
    return PredictionData(
      id: json['id'],
      prediction: json['prediction'],
      confidence: json['confidence']?.toDouble(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prediction': prediction,
      'confidence': confidence,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}