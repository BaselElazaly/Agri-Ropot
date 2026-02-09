class SensorDataModel {
  final int minTemperature;
  final double avgTemperature;
  final int maxTemperature;

  final int minSoil;
  final double avgSoil;
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
      minTemperature: json['minTemperature'],
      avgTemperature: json['avgTemperature'] * 1.0,
      maxTemperature: json['maxTemperature'],
      minSoil: json['minSoil'],
      avgSoil: json['avgSoil'] * 1.0,
      maxSoil: json['maxSoil'],

    );
  }
}
