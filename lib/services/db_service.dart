import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/trip_model.dart';

class DBService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

//Fetch Data
  Stream<List<TripModel>> getTripData(String uid) {
    return _db.collection('trips').where('userId', isEqualTo: uid).orderBy(
        'date', descending: true).snapshots().map((snapshots){
          return snapshots.docs.map((doc){
            return TripModel.fromMap( doc.data(), doc.id);
          }).toList();
    });
  }


  //delet data
  Future<void> _deletTrip(String tripId) async {
    _db.collection('trips').doc(tripId).delete();
  }


}