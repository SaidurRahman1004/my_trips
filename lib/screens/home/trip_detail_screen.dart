import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_trips/models/trip_model.dart';

import '../../widgets/CustomText.dart';
import '../../widgets/custom_button.dart';

class TripDetailScreen extends StatefulWidget {
  final TripModel trip;

  const TripDetailScreen({super.key, required this.trip});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Hero(
                    tag: widget.trip.id,
                    child: Image.network(
                      widget.trip.imageUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),

                  Positioned(
                    top: 10,
                    left: 10,
                    child: InkWell(
                      onTap: () => context.go('/home'),
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.5),
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red, size: 15),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Txt(
                      txt: widget.trip.location,
                      fntSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Divider(color: Colors.blue, thickness: 1),
              const SizedBox(height: 10),
              Txt(txt: 'The Story', fntSize: 25, fontWeight: FontWeight.bold),
              const SizedBox(height: 15),
              Txt(
                txt: widget.trip.description,
                fntSize: 15,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
              CustomButton(
                buttonName: 'Back',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
