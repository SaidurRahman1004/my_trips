import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_trips/widgets/CenterCircularProgressIndicator.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/trip_model.dart';
import '../../services/db_service.dart';
import '../../services/location_service.dart';
import 'package:my_trips/widgets/CustomText.dart';
import 'package:my_trips/widgets/custom_button.dart';
import '../../Core/constant.dart';
import '../../services/auth_service.dart';
import '../../widgets/custo_snk.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_text_field.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

class AddTripScreen extends StatefulWidget {
  AddTripScreen({super.key});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final TextEditingController _titleCtrler = TextEditingController();

  final TextEditingController _detailCtrler = TextEditingController();

  final DBService _dbService = DBService();
  final LocationService _locationService = LocationService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  File? _imageFile;
  Uint8List? _imageBytes; //image for web
  double? _lat, _lon;
  String _locationAddress = 'Location  not set';
  final Uuid _uuid = Uuid();
  final ImagePicker _picker = ImagePicker();

  //PickImage Functions
  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 50,
      maxWidth: 800,
    );
    if (image != null) {
      if (kIsWeb) {
        final databyte = await image.readAsBytes();
        setState(() {
          _imageBytes = databyte;
        });
      } else {
        setState(() {
          _imageFile = File(image.path);
        });
      }
    }
  }

  //Location Functions For Lat Kon Adress
  Future<void> _fetchLocation() async {
    final location = await _locationService.getCurrentLocation();
    if (location != null) {
      final address = await _locationService.getLocationAddress(
        location.latitude,
        location.longitude,
      );
      setState(() {
        _lat = location.latitude;
        _lon = location.longitude;
        _locationAddress = address;
      });
    }
  }

  @override
  void dispose() {
    _titleCtrler.dispose();
    _detailCtrler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Txt(txt: 'TravelSnap'),
        leading: IconButton(
          onPressed: () {
            context.go('/home');
          },
          icon: Icon(Icons.arrow_back_outlined),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Txt(
                  txt: 'Add new trip',
                  fntSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                Txt(
                  txt: 'Save your travel memories',
                  fntSize: 15,
                  color: Colors.grey,
                ),

                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Txt(
                        txt: 'Trip Photo',
                        fntSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: ()=>_pickImage(ImageSource.camera),
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: (kIsWeb && _imageBytes != null)
                              ? Image.memory(
                                  _imageBytes!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200,
                                )
                              : (!kIsWeb && _imageFile != null)
                              ? Image.file(
                                  _imageFile!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200,
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.grey,
                                      size: 50,
                                    ),
                                    Txt(
                                      txt: 'Tap to Take or select a photo',
                                      fntSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Txt(
                        txt: 'Trip Title',
                        fntSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _titleCtrler,
                        lableText: 'Enter Trip Title',
                        hintText: 'e.g. Trip to Paris',
                      ),
                      const SizedBox(height: 10),

                      Txt(
                        txt: 'Description',
                        fntSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _detailCtrler,
                        lableText: 'Write About Your Trip',
                        hintText: 'e.g. Trip to Paris',
                        maxLine: 7,
                      ),
                      const SizedBox(height: 20),

                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 380,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 5,
                            right: 0,
                            child: Container(
                              width: double.infinity,
                              height: 400,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_rounded,
                                          color: Colors.red,
                                          size: 35,
                                        ),
                                        Txt(
                                          txt: 'Trip Location',
                                          fntSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 30),
                                    Txt(
                                      txt: _locationAddress,
                                      fntSize: 18,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 40),
                                    Txt(
                                      txt: 'Latitude:  ${_lat ?? '__'}',
                                      fntSize: 17,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 40),
                                    Txt(
                                      txt: 'Longitude: ${_lon ?? '__'}',
                                      fntSize: 17,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 50),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: CustomButton(
                                        buttonName: "Get Location",
                                        onPressed: _locationPressed,
                                        icon: Icons.location_pin,
                                        width: 220,
                                        height: 50,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Visibility(
                        visible: _isLoading == false,
                        replacement: CenterCircularProgressIndicator(),
                        child: CustomButton(
                          icon: Icons.save,
                          buttonName: 'Save Your Memory',
                          onPressed: _onSaveMemory,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onProfileRouter() {}

  void _locationPressed() {
    _fetchLocation();
  }

  Future<void> _onSaveMemory() async {
    //Validation
    if (_titleCtrler.text.isEmpty ||
        (_imageFile == null && _imageBytes == null) ||
        _lat == null) {
      mySnkmsg('Please fill all the fields', context);
      return;
    }
    //Loaading Start
    setState(() {
      _isLoading = true;
    });

    try {
      //Upload Image to Imgbb and return ImageLink Web and Phone
      // String imageUrl = await _dbService.uploadImage(_imageFile!); //Only Web
      String imageUrl = '';
      if (kIsWeb && _imageBytes != null) {
        //imageUrl = await _dbService.uploadImage(_imageFile!);
        mySnkmsg('WEB Image UploaDING YET ,PLEASE WAIT', context);
      } else if (!kIsWeb && _imageFile != null) {
        imageUrl = await _dbService.uploadImage(_imageFile!);
      }

      //Create Trip Object Using Trip Model
      final newTrip = TripModel(
        id: _uuid.v4(),
        userId: _auth.currentUser!.uid,
        title: _titleCtrler.text,
        description: _detailCtrler.text,
        location: _locationAddress,
        latitude: _lat!,
        longitude: _lon!,
        imageUrl: imageUrl,
        date: DateTime.now(),
      );

      //sent 'newTrip' all  data to firebase throw dbService
      await _dbService.saveTrip(newTrip);
      if (mounted) {
        mySnkmsg('Trip Saved Successfully', context);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _titleCtrler.clear();
            _detailCtrler.clear();
            context.go('/home');
          }
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
