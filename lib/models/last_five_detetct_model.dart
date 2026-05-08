class DetectionModel {
  int? id;
  String? imageUrl;
  int? labelCount;
  String? receivedDate; 
  List<DetectionItem>? detections;

  DetectionModel({
    this.id,
    this.imageUrl,
    this.labelCount,
    this.receivedDate, 
    this.detections,
  });

  DetectionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    
    String? rawImage = json['imageUrl'] ?? json['image'];
    
    if (rawImage != null && rawImage.startsWith('/images/')) {
      imageUrl = 'https://finalgraduationproject.runasp.net$rawImage';
    } else {
      imageUrl = rawImage;
    }

    labelCount = json['labelCount'] ?? json['count'];
    
    receivedDate = json['receivedDate'] ?? json['createdAt'];
    
    var detectionList = json['detection'] ?? json['predictions'];
    
    if (detectionList != null) {
      detections = <DetectionItem>[];
      detectionList.forEach((v) {
        detections!.add(DetectionItem.fromJson(v));
      });
    } else {
      detections = [];
    }
  }
}

class DetectionItem {
  int? id;
  String? label;
  double? confidence;
  String? status;
  List<String>? recommendation;

  DetectionItem({
    this.id,
    this.label,
    this.confidence,
    this.status,
    this.recommendation,
  });

  DetectionItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    
    if (json['confidence'] != null) {
      double rawConfidence = json['confidence']?.toDouble() ?? 0.0;
      confidence = double.parse((rawConfidence * 100).toStringAsFixed(1)); 
    } else {
      confidence = 0.0;
    }

    status = json['status'];
    
    var recList = json['recommendation'] ?? json['recommendations'];
    if (recList != null) {
      recommendation = List<String>.from(recList);
    } else {
      recommendation = [];
    }
  }
}