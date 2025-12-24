

import 'package:cloud_firestore/cloud_firestore.dart';
class TripModel {
  String id;             // unique id of trip
  String userId;         // user who created the trip
  String title;          // name of trip
  String description;    // trip description
  String location;       // trip location from geocoading
  double latitude;       // lat for map
  double longitude;      // long for map
  String imageUrl;       // image link from Storage
  DateTime date;     // date of trip
  bool isPublic;
  String userName;
  String? userPhoto;
  int likesCount;
  int commentsCount;


  TripModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.date,
    this.isPublic = false,
    required this.userName,
    this.userPhoto,
    this.likesCount = 0,
    this.commentsCount = 0,
});

  //Serialization App Object to  Map json

Map<String, dynamic> toMap(){
  return{
    'id': id,
    'userId': userId,
    'title': title,
    'description': description,
    'location': location,
    'latitude': latitude,
    'longitude': longitude,
    'imageUrl': imageUrl,
    'date': Timestamp.fromDate(date),
    'isPublic': isPublic,
    'userName': userName,
    'userPhoto': userPhoto,
    'likesCount': likesCount,
    'commentsCount': commentsCount,



  };
}

//Deserialization Map json to App Object

factory TripModel.fromMap(Map<String, dynamic> map, String documentId){
  return TripModel(
      id: documentId,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      latitude: (map['latitude'] ??  0.0).toDouble(),
      longitude:(map['longitude'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      isPublic: map['isPublic'] ?? false,
      userName: map['userName'] ?? 'Unknown',
      userPhoto: map['userPhoto'],
      likesCount: map['likesCount'] ?? 0,
      commentsCount: map['commentsCount'] ?? 0,


  );
}




}