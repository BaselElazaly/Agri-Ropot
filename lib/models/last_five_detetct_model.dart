import 'package:intl/intl.dart';

class DetectionModel {
  int? id;
  String? label;
  String? receivedDate;
  double? confidence; 
  String? imageUrl;

  DetectionModel({this.id, this.label, this.receivedDate, this.confidence, this.imageUrl});

  DetectionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    receivedDate = json['receivedDate'];
    
    if (json['confidence'] != null) {
      double rawConfidence = json['confidence']?.toDouble() ?? 0.0;
      confidence = double.parse((rawConfidence * 100).toStringAsFixed(1)); 
    } else {
      confidence = 0.0;
    }

    imageUrl = json['imageUrl'];
  }



}