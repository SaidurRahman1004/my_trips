import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_trips/widgets/CustomText.dart';

import '../../widgets/profile_cards.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    const double outerRadius = 70;
    const double innerRadius = 65;
    const double avatarDiameter = outerRadius * 2;
    const double cameraRadius = 20;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Txt(txt: 'My Profile', fontWeight: FontWeight.bold, fntSize: 25),
        elevation: 10,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop,
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(radius: outerRadius, backgroundColor: Colors.white),
                  CircleAvatar(
                    radius: innerRadius,
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(
                      Icons.person,
                      size: 120,
                      color: Colors.grey.shade400,
                    ),
                  ),

                  Positioned(
                    bottom: 8,
                    right: 0,
                    child: Material(
                      color: Colors.blue,
                      shape: const CircleBorder(
                        side: BorderSide(
                          color: Colors.white,
                          width: 3,
                        )
                      ),
                      elevation: 4,
                      child: InkWell(
                        onTap: (){},
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
            Txt(txt: 'Name',fntSize: 28,fontWeight: FontWeight.bold,),
            Txt(txt: 'Email',fntSize: 16,color: Colors.grey,),

            const SizedBox(height: 20),

            ProfileCard(icon: Icons.credit_card, titlr: 'User Id', description: 'kdkwdk')



          ],
        ),
      ),
    );
  }
}
