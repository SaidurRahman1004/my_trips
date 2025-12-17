import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_trips/widgets/CustomText.dart';

import '../Core/constant.dart';
import '../services/auth_service.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showProfileIcon;

  const CustomAppBar(
      {super.key, required this.title, required this.showProfileIcon});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: Icon(Icons.trip_origin, size: 50, color: Colors.amber),
      title: Txt(
        txt: title, fontWeight: FontWeight.bold, color: Colors.black87,),
      actions: [
        if(showProfileIcon)
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: InkWell(
                onTap: onProfileRouter,
                child: CircleAvatar(
                  backgroundColor: Colors.amber.shade100,
                  radius: 20,
                  backgroundImage: user?.photoURL != null?
                  NetworkImage(user!.photoURL!):null,
                  child: user?.photoURL == null ? Icon(Icons.person,color: Colors.amber,):null,
                ),

            ),
          ),

        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => AuthService().logOut(),
        ),
      ],
    );
  }

  void onProfileRouter() {
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
