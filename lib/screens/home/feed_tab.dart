import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_trips/services/db_service.dart';
import 'package:my_trips/widgets/CustomText.dart';
import 'package:my_trips/widgets/feed_post_card.dart';

import '../../models/trip_model.dart';
import '../../widgets/CenterCircularProgressIndicator.dart';
import '../../widgets/trip_card.dart';

class FeedTab extends StatefulWidget {
  const FeedTab({super.key});

  @override
  State<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  final DBService _dbService = DBService();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.amber,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Txt(
                    txt: 'Community Feed',
                    fontWeight: FontWeight.bold,
                    fntSize: 24,
                  ),
                  Txt(
                    txt: 'Discover travel stories from around the world',
                    color: Colors.grey,
                    fntSize: 12,
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: StreamBuilder<List<TripModel>>(
                      stream: _dbService.getPublicTripData(),
                      builder: (_, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CenterCircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 60,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 16),
                                Txt(txt: 'Error loading feed', fntSize: 16),
                                const SizedBox(height: 8),
                                Txt(
                                  txt: snapshot.error.toString(),
                                  fntSize: 12,
                                  color: Colors.grey,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }

                        final publicTrips = snapshot.data ?? [];

                        if (publicTrips == null || publicTrips.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.warning_amber,
                                  size: 80,
                                  color: Colors.amber,
                                ),
                                const SizedBox(height: 10),
                                Txt(
                                  txt: "No Trips Found",
                                  fntSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),

                                const SizedBox(height: 10),
                                Text(
                                  "Add your first trip",
                                  style: GoogleFonts.poppins(fontSize: 15),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: publicTrips.length,
                          padding: const EdgeInsets.only(bottom: 80),
                          itemBuilder: (context, index) {
                            final AccesstripList = publicTrips[index];
                            return TweenAnimationBuilder(
                              tween: Tween<double>(begin: 0, end: 1),
                              duration: Duration(
                                milliseconds: 400 + (index * 100),
                              ),
                              builder:
                                  (BuildContext context, double value, child) {
                                    return Opacity(
                                      opacity: value,
                                      child: Transform.translate(
                                        offset: Offset(0, 30 * (1 - value)),
                                        child: child,
                                      ),
                                    );
                                  },
                              child: FeedPostCard(trip: AccesstripList, currentUserId: currentUser!.uid),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onRefresh: () async {
        setState(() {});
      },
    );
  }
}
