import 'package:cloud_firestore/cloud_firestore.dart';

class LikeModel {
  String id; //Liked Id
  String tripId; //Which Id
  String userId; //Who liked
  DateTime timestamp; //When

  LikeModel({
    required this.id,
    required this.tripId,
    required this.userId,
    required this.timestamp,
  });

  //to json
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tripId': tripId,
      'userId': userId,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  //From JSON
  factory LikeModel.fromMap(Map<String, dynamic> map, String documentId){
    return LikeModel(id: documentId,
        tripId: map['tripId'] ?? '',
        userId: map['userId'] ?? '',
        timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
