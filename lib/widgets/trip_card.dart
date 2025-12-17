import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_trips/models/trip_model.dart';
import 'package:intl/intl.dart';
import 'package:my_trips/widgets/CustomText.dart';

import 'custom_button.dart';

class TripCard extends StatelessWidget {
  final TripModel tripModel;
  final VoidCallback onDelete;

  const TripCard({super.key, required this.tripModel, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Stack(
            children: [
              Hero(
                tag: tripModel.id,
                child: ClipRect(
                  child: Image.network(
                    tripModel.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        color: Colors.grey.shade100,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.amber,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },

                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey.shade100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.red,
                              size: 50,
                            ),
                            Txt(txt: ' Image Not Available', fntSize: 15,color: Colors.grey,)
                          ],

                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.5),
                  child: IconButton(
                    onPressed: onDelete,
                    icon: Icon(Icons.delete),
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tripModel.title,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white, size: 15),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            tripModel.location,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.grey, size: 15),
                    const SizedBox(width: 5),
                    Text(
                      DateFormat('dd/MM/yyyy ').format(tripModel.date),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        tripModel.description,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    CustomButton(
                      buttonName: "Details",
                      onPressed: () => context.go('/details', extra: tripModel),
                      icon: Icons.read_more,
                      width: 150,
                      height: 50,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
