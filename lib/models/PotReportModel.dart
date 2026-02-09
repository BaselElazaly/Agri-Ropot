import 'dart:convert';
import 'dart:typed_data';

class PotReportModel {
  final int potId;
  final int potNumber;
  final Uint8List? image;
  final DateTime dateTime;
  final List<int> allTemperature;
  final List<int> allSoil;
  final List<int> allHealth;
  final int avgTemperature;
  final int avgSoil;
  final int avgHealth;


  PotReportModel({
    required this.potId,
    required this.potNumber,
    this.image,
    required this.dateTime,
    required this.allTemperature,
    required this.allSoil,
    required this.allHealth,
    required this.avgTemperature,
    required this.avgSoil,
    required this.avgHealth,
  });

  factory PotReportModel.fromJson(Map<String, dynamic> json) {
    final potStatics = json['potStatics'] ?? {};
    return PotReportModel(
      potId: json['potId'],
      potNumber: json['potNumber'],
      image: json['file'] != null ? base64Decode(json['file']) : null,
      dateTime: DateTime.parse(json['date']).toLocal(),
      allTemperature: List<int>.from(potStatics['allTemperature'] ?? []),
      allSoil: List<int>.from(potStatics['allSoil'] ?? []),
      allHealth: List<int>.from(potStatics['allHealth'] ?? []),
      avgTemperature: ((potStatics['avgTemperature'] ?? 0) as num).round(),
      avgSoil: ((potStatics['avgSoil'] ?? 0) as num).round(),
      avgHealth: (potStatics['avgHealth'] ?? 0),


    );
  }
}
