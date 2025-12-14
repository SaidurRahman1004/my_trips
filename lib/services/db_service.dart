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
    return _db.collection('trips').where('userId', isEqualTo: uid).orderBy(
        'date', descending: true).limit(50).snapshots().map((snapshots){
          return snapshots.docs.map((doc){
            return TripModel.fromMap( doc.data(), doc.id);
          }).toList();
    });
  }

  //Save or Put data
  Future<void> saveTrip(TripModel tripModel) async{
    await _db.collection('trips').doc(tripModel.id).set(tripModel.toMap());
  }


  //delet data
  Future<void> deletTrip(String tripId) async {
    _db.collection('trips').doc(tripId).delete();
  }

  //Image Upload Function Or Image Storage //Not Firebase Storage
  Future<String> uploadImage(File imageFile) async{
    try{
      //create request
      var request = http.MultipartRequest('POST', Uri.parse('https://api.imgbb.com/1/upload?key=${AppConst.imageAPIKey}')); //create request

      // add image file to request //'image'feild of imgbb
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
      //sent Request
      var response = await request.send();

      //if response seccess
      if(response.statusCode == 200){
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        return jsonResponse['data']['url']; //return image url Direct
      }else{
        throw Exception('Failed to upload image');
      }


    }catch(e){
      throw Exception(e.toString());
      return '';

    }

  }


}