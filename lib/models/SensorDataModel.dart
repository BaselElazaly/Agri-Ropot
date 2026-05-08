class SensorDataModel {
  final int minTemperature;
  final int avgTemperature;
  final int maxTemperature;

  final int minSoil;
  final int avgSoil;
  final int maxSoil;

  SensorDataModel({
    required this.minTemperature,
    required this.avgTemperature,
    required this.maxTemperature,
    required this.minSoil,
    required this.avgSoil,
    required this.maxSoil,
  });

  factory SensorDataModel.fromJson(Map<String, dynamic> json) {
    return SensorDataModel(
      minTemperature: (json['minTemperature'] as num?)?.toInt() ?? 0,
      avgTemperature: (json['avgTemperature'] as num?)?.toInt() ?? 0,
      maxTemperature: (json['maxTemperature'] as num?)?.toInt() ?? 0,
      minSoil: (json['minSoil'] as num?)?.toInt() ?? 0,
      avgSoil: (json['avgSoil'] as num?)?.toInt() ?? 0,
      maxSoil: (json['maxSoil'] as num?)?.toInt() ?? 0,
    );
  }
}