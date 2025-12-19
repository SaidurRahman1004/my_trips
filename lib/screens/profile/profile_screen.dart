import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_trips/services/auth_service.dart';
import 'package:my_trips/widgets/CenterCircularProgressIndicator.dart';
import 'package:my_trips/widgets/CustomText.dart';
import 'package:my_trips/widgets/custo_snk.dart';
import 'package:my_trips/widgets/custom_button.dart';
import 'package:my_trips/widgets/custom_text_field.dart';

import '../../services/db_service.dart';
import '../../widgets/profile_cards.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final _dbService = DBService();
  final _auth = AuthService();
  bool _isLoading = false;

  //Upluad Image Functions
  Future<void> _uploadImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 800,
    );
    if (image == null) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final imageUrl = await _dbService.uploadImage(File(image.path));
      user?.updatePhotoURL(imageUrl);
      user?.reload(); //reload user data
      setState(() {
        user = FirebaseAuth.instance.currentUser;
      });
      if (mounted) {
        mySnkmsg('Image Uploaded Successfully', context);
      }
    } catch (e) {
      if (mounted) {
        mySnkmsg(e.toString(), context);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //Edit Name Functions
  Future<void> _updateName() async {
    final TextEditingController _titleCtrl = TextEditingController(
      text: user?.displayName,
    );
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Txt(
            txt: 'Edit Name',
            fontWeight: FontWeight.bold,
            fntSize: 20,
          ),
          content: CustomTextField(
            controller: _titleCtrl,
            lableText: 'Name',
            hintText: 'Enter New Name',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Txt(txt: 'Cencle'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_titleCtrl.text.isNotEmpty) {
                  Navigator.pop(context);
                }
                setState(() {
                  _isLoading = true;
                });

                try {
                  await user?.updateDisplayName(_titleCtrl.text.trim());
                  await user?.reload();
                  setState(() {
                    user = FirebaseAuth.instance.currentUser;
                  });
                  if (mounted) {
                    mySnkmsg('Name Updated Successfully', context);
                  }
                } catch (e) {
                  if (mounted) {
                    mySnkmsg(e.toString(), context);
                  }
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              child: Txt(txt: 'Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const double outerRadius = 70;
    const double innerRadius = 65;
    const double avatarDiameter = outerRadius * 2;
    const double cameraRadius = 20;
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Txt(txt: 'My Profile', fontWeight: FontWeight.bold, fntSize: 25),
        elevation: 10,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),

      body: Visibility(
        visible: _isLoading == false,
        replacement: CenterCircularProgressIndicator(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: outerRadius,
                        backgroundColor: Colors.white,
                      ),
                      CircleAvatar(
                        radius: innerRadius,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: user?.photoURL != null
                            ? NetworkImage(user!.photoURL!)
                            : null,
                        child: user?.photoURL == null
                            ? Icon(
                                Icons.person,
                                size: 120,
                                color: Colors.grey.shade400,
                              )
                            : null,
                      ),

                      Positioned(
                        bottom: 8,
                        right: 0,
                        child: Material(
                          color: Colors.blue,
                          shape: const CircleBorder(
                            side: BorderSide(color: Colors.white, width: 3),
                          ),
                          elevation: 4,
                          child: InkWell(
                            onTap: () {
                              _uploadImage();
                            },
                            customBorder: const CircleBorder(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.amber,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Txt(
                      txt: user?.displayName ?? 'No Name',
                      fntSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    IconButton(onPressed: (){
                      _updateName();
                    }, icon: Icon(Icons.edit_note,size: 40,color: Colors.blue,)),

                  ],
                ),

                Txt(
                  txt: user?.email ?? 'No Email',
                  fntSize: 16,
                  color: Colors.grey,
                ),

                const SizedBox(height: 20),

                ProfileCard(
                  icon: Icons.verified_user,
                  title: 'User Id',
                  description: user?.uid ?? 'N/A',
                ),
                SizedBox(height: 10),
                ProfileCard(
                  icon: Icons.date_range,
                  title: 'Joined Date',
                  description: user?.metadata.creationTime != null
                      ? user!.metadata.creationTime.toString().split(' ')[0]
                      : 'N/A',
                ),
                const SizedBox(height: 30),
                CustomButton(
                  buttonName: 'Log Out',
                  icon: Icons.logout,
                  onPressed: () {
                    _auth.logOut();
                    context.go('/login');

                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
