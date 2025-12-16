import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_trips/models/trip_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/CustomText.dart';
import '../../widgets/custom_button.dart';

class TripDetailScreen extends StatelessWidget {
  final TripModel trip;

  const TripDetailScreen({super.key, required this.trip});

  Future<void> _openMap() async {
    final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=${trip
        .latitude},${trip.longitude}';
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    }
  }

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
                    tag: trip.id,
                    child: Image.network(
                      trip.imageUrl,
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
                        backgroundColor: Colors.white,
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Txt(
                txt: trip.title,
                fntSize: 25,
                fontWeight: FontWeight.bold,
              ),
              Row(
                children: [
                  Icon(Icons.calendar_month, color: Colors.red, size: 15),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Txt(
                      txt: DateFormat('dd MMMM, yyyy').format(trip.date),
                      fntSize: 15,
                      color: Colors.blue.shade400,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red, size: 15),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Txt(
                      txt: trip.location,
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
                txt: trip.description,
                fntSize: 15,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
              CustomButton(
                icon: Icons.map_outlined,
                buttonName: 'Open Google Maps',
                onPressed: () => _openMap(),
                color: Colors.amber,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
