import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_trips/models/trip_model.dart';
import 'package:my_trips/widgets/CenterCircularProgressIndicator.dart';
import 'package:my_trips/widgets/custo_snk.dart';
import '../../services/db_service.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/search_widget.dart';
import '../../widgets/trip_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DBService _dbService = DBService();
  User? currentuser = FirebaseAuth.instance.currentUser;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'TravelSnap', showProfileIcon: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Memories of your travel",
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            FutureBuilder<DateTime?>(
              future: _dbService.getLastUpdatedDate(currentuser!.uid),
              builder: (context,snapshot) {
                if(snapshot.hasData && snapshot != null){
                  String formattedLastDate= DateFormat('dd/MM/yyyy').format(snapshot.data!);
                  return Text(
                    "Last Updated: ${formattedLastDate}",
                    style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey),
                  );

                }else{
                  return const SizedBox();
                }

              }
            ),
            const SizedBox(height: 10),
            TripSearchWidget(
              onSearch: (onSearchquery) {
                setState(() {
                  _searchQuery = onSearchquery;
                });
              },
            ),
            const SizedBox(height: 10),
            Text(
              "Your Trips",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<TripModel>>(
                stream: _dbService.getTripData(currentuser!.uid),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CenterCircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }

                  final tripsList = snapshot.data ?? [];

                  if (tripsList == null || tripsList.isEmpty) {
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
                          Text(
                            "No Trips Found",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
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
                    itemCount: tripsList.length,
                    itemBuilder: (context, index) {
                      final AccesstripList = tripsList[index];
                      return TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: Duration(milliseconds: 400 + (index * 100)),
                        builder:
                            (
                              BuildContext context,
                              double value,
                              child,
                            ) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(offset: Offset(0, 30*(1-value)),
                              child: child,
                            ),
                          );
                            },
                        child: TripCard(
                          tripModel: AccesstripList,
                          onDelete: () {
                            _showDeleteDialog(context, AccesstripList.id);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        hoverElevation: 5,
        onPressed: _onAddTrip,
        child: const Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
    );
  }



  void _onAddTrip() {
    context.go('/addscreen');
  }

  //Delete Alert Dialog
  Future<void> _showDeleteDialog(context, String tripId) async {
    final bool? _confirmDelete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Trip'),
        content: Text('Are you sure you want to delete this trip?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
    if (_confirmDelete == true) {
      try {
        await _dbService.deletTrip(tripId);
        if (mounted) {
          mySnkmsg('Trip Deleted Successfully', context);
        }
      } catch (e) {
        if (mounted) {
          mySnkmsg(e.toString(), context);
        }
      }
    }
  }
}
