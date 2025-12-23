import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  //Function For Find Current Location using geolocator
  Future<Position?> getCurrentLocation() async {
    bool locationServiceEnabled;
    LocationPermission locationPermission;
    //Cheak LocationService Enable Or Disable
    locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationServiceEnabled) {
      Geolocator.openAppSettings();
      return Future.error('Location Service is Disable');
    }
    //Check  App Location Permission Status
    locationPermission = await Geolocator.checkPermission();
    if(locationPermission == LocationPermission.deniedForever){
      await Geolocator.openAppSettings();
      return Future.error('Location Permission is Denied');
    }
    if(locationPermission == LocationPermission.denied){
      locationPermission = await Geolocator.requestPermission();
      if(locationPermission == LocationPermission.denied){
        await Geolocator.openAppSettings();
        return Future.error('Location Permission is Denied');
      }
    }
    //Get Current Location
    return await Geolocator.getCurrentPosition(
       desiredAccuracy: LocationAccuracy.high,
       forceAndroidLocationManager: true,

    );

  }

  //Function For Find Current Location in ReadAble Adress using geocoding
  Future<String> getLocationAddress(double lat, double lon) async {
    try {
      //Fetch Readable Address from Current Location
      //This function in the geocoding package retrieves a list of possible addresses from the internet using lat and lng.
      List<Placemark> place = await placemarkFromCoordinates(lat, lon);

      if(place.isNotEmpty){
        //The first item in the list (placemarks[0]) is usually the most accurate address. That address is stored in the place variable.
        Placemark placemark = place[0];
        return "${placemark.locality ?? ''}, ${placemark.subAdministrativeArea ?? ''}, ${placemark.country ?? ''}"; //Return Readable Address in String Format
      }

    } catch (e) {
      print(e.toString());
    }
    return 'Unknown Location';
  }
}
