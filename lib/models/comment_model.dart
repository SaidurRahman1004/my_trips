import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String id; //Liked Id
  String tripId; //Which Id
  String userId; //Who liked
  String userName; // Commenter's name
  String? userPhotoUrl; // Commenter's photo
  String comment; //Comment
  DateTime timestamp; //When

  CommentModel({
    required this.id,
    required this.tripId,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.comment,
    required this.timestamp,
  });

  //to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tripId': tripId,
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'comment': comment,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map, String documentId) {
    return CommentModel(
      id: documentId,
      tripId: map['tripId'] ?? '',
      userId: map ['userId'] ?? '',
      userName: map['userName'] ?? 'Unknown',
      userPhotoUrl: map['userPhotoUrl'],
      comment: map['comment'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
