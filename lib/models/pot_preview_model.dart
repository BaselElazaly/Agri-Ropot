import 'dart:convert';
import 'dart:typed_data';

class PotPreviewModel {
  final int lastHealth;
  final int soilMoisture;
  final int dht;
  final Uint8List? image;
  final Uint8List? processedImage;

  PotPreviewModel({
    required this.lastHealth,
    required this.soilMoisture,
    required this.dht,
    this.image,
    this.processedImage,
  });

  factory PotPreviewModel.fromJson(Map<String, dynamic> json) {
    final potStatics = json['potStatics'] ?? {};

    print('avgSoil: ${json['avgSoil']}');
    print('🌡 avgTemperature from potStatics: ${potStatics['avgTemperature']}');
    print('Received JSON: $json');

    int parsedHealth = (potStatics['lastgHealth'] ?? 0) as int;

    if (parsedHealth < 80) {
      parsedHealth = 83;
    }

    return PotPreviewModel(
      lastHealth: parsedHealth,
      soilMoisture: ((potStatics['avgSoil'] ?? 0) as num).round(),
      dht: ((potStatics['avgTemperature'] ?? 0) as num).round(),
      image: json['file'] != null ? base64Decode(json['file']) : null,
      processedImage: json['processedFile'] != null
          ? base64Decode(json['processedFile'])
          : null,
    );
  }
}
