import 'package:flutter/material.dart';
import 'package:my_trips/widgets/CustomText.dart';

class ProfileCard extends StatelessWidget {
  final IconData icon;
  final String titlr;
  final String description;
  const ProfileCard({super.key, required this.icon, required this.titlr, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Expanded(
          child: Container(
            width: double.infinity,
            //color: Colors.white,
            child: Row(
              children: [
                Material(
                  elevation: 4,
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Center(
                      child: Icon(icon,size: 40,color: Colors.blue,),
                    ),
                  ),

                ),
                const SizedBox(width: 15),
                Column(
                  children: [
                    Txt(txt: titlr,fntSize: 16,color: Colors.grey,),
                    Txt(txt: description,fntSize: 16,fontWeight: FontWeight.bold,),

                  ],
                )


              ],


          ),
        ),
      ),

    ));
  }
}
