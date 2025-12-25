import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Core/constant.dart';
import '../models/trip_model.dart';

class DBService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //Fetch Data
  Stream<List<TripModel>> getTripData(String uid) {
    return _db
        .collection('trips')
        .where('userId', isEqualTo: uid)
        .orderBy('date', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshots) {
          return snapshots.docs.map((doc) {
            return TripModel.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  //Get New Public Post only
  Stream<List<TripModel>> getPublicTripData(String uid) {
    return _db
        .collection('trips')
        .where('isPublic', isEqualTo: true)
        .orderBy('date', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshots) {
          return snapshots.docs.map((doc) {
            return TripModel.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  //Save or Put data
  Future<void> saveTrip(TripModel tripModel) async {
    await _db.collection('trips').doc(tripModel.id).set(tripModel.toMap());
  }

  //delet data
  Future<void> deletTrip(String tripId) async {
    _db.collection('trips').doc(tripId).delete();
  }

  //Find Last Updated Post
  Future<DateTime?> getLastUpdatedDate(String uid) async {
    try {
      final querySnapshot = await _db
          .collection('trips')
          .where('userId', isEqualTo: uid)
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return (querySnapshot.docs.first.data()['date'] as Timestamp).toDate();
      }
      return null;
    } catch (e) {
      print("Error getting last updated date: $e");
      return null;
    }
  }

  //Image Upload Function Or Image Storage //Not Firebase Storage
  Future<String> uploadImage(File imageFile) async {
    try {
      //create request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.imgbb.com/1/upload?key=${AppConst.imageAPIKey}'),
      ); //create request

      // add image file to request //'image'feild of imgbb
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
      //sent Request
      var response = await request.send();

      //if response seccess
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        return jsonResponse['data']['url']; //return image url Direct
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //Like Trip Logic
  Future<void> likeTrip(String tripId, String userId) async {
    try {
      final likeId = '${userId}_$tripId';
      final likeRef = await _db.collection('likes').doc(likeId).get();
      if (likeRef.exists) {
        //find alredy liked
        await _db.collection('likes').doc(likeId).delete();
        //Decrement Like
        await _db.collection('trips').doc(tripId).update({
          'likesCount': FieldValue.increment(-1),
        });
      } else {
        await _db.collection('likes').doc(likeId).set({
          'id': likeId,
          'tripId': tripId,
          'userId': userId,
          'timestamp': FieldValue.serverTimestamp(),
        });
        //Increment Like
        await _db.collection('trips').doc(tripId).update({
          'likesCount': FieldValue.increment(1),
        });
      }
    } catch (e) {
      print('Like error: $e');
      throw Exception(e.toString());
    }
  }

  //cheak User Already Liked For Ui
  Future<bool> isUserLiked(String tripId, String userId) async {
    try {
      final likeId = '${userId}_$tripId';
      final likeRef = await _db.collection('likes').doc(likeId).get();
      return likeRef.exists;
    } catch (e) {
      return false;
    }
  }

  //Find All Coments for  Specific Trip
  Stream<QuerySnapshot> getComments(String tripId) {
    return _db
        .collection('comments')
        .where('tripId', isEqualTo: tripId)
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  //Add or Save Comment
  Future<void> addComment({
    required String tripId,
    required String userId,
    required String userName,
    required String? userPhotoUrl,
    required String comment,
  }) async {
    try{
      final commentRef = _db.collection('comments').doc();
      await commentRef.set({
        'id': commentRef.id,
        'tripId': tripId,
        'userId': userId,
        'userName': userName,
        'userPhotoUrl': userPhotoUrl,
        'comment': comment,
        'timestamp': FieldValue.serverTimestamp(),
      });
      //Increment Comment Count
      await _db.collection('trips').doc(tripId).update({
        'commentsCount': FieldValue.increment(1),
      });
    }catch(e){
      print('Comment error: $e');
      throw Exception(e.toString());
    }
  }
  Future<void> deleteComment(String commentId, String tripId) async{
    try{
      await _db.collection('comments').doc(commentId).delete();
      await _db.collection('trips').doc(tripId).update({
        'commentsCount': FieldValue.increment(-1),
      });
    }catch(e){
      print('Comment error: $e');
      throw Exception(e.toString());
    }
  }
}
