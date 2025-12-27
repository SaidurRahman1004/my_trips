import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_trips/models/trip_model.dart';
import 'package:my_trips/widgets/CenterCircularProgressIndicator.dart';
import 'package:my_trips/widgets/CustomText.dart';
import 'package:my_trips/widgets/custo_snk.dart';
import '../../services/db_service.dart';
import '../../widgets/search_widget.dart';
import '../../widgets/trip_card.dart';

class MyTripsTab extends StatefulWidget {
  const MyTripsTab({super.key});

  @override
  State<MyTripsTab> createState() => _MyTripsTabState();
}

class _MyTripsTabState extends State<MyTripsTab> {
  final DBService _dbService = DBService();
  final User? currentuser = FirebaseAuth.instance.currentUser;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    if (currentuser == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Txt(txt: 'My Travel Memories',fntSize: 24,fontWeight: FontWeight.bold,),
          const SizedBox(height: 5),
          FutureBuilder<DateTime?>(
              future: _dbService.getLastUpdatedDate(currentuser!.uid),
              builder: (context,snapshot) {
                if(snapshot.hasData && snapshot != null){
                  String formattedLastDate= DateFormat('dd/MM/yyyy').format(snapshot.data!);
                  return Txt(txt: 'Last Updated: ${formattedLastDate}',fntSize: 15,color: Colors.grey,);

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
                  return Txt(txt: 'Error: ${snapshot.error}');
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
                        Txt(txt: 'No Trips Found',fntSize: 20,fontWeight: FontWeight.bold,),

                        const SizedBox(height: 10),
                        Txt(txt: 'Add your first travel memory!',fntSize: 14,),
                      ],
                    ),
                  );
                }

                //if search bax has any content then try to filter otherwise show all
                final tripFilterd = tripsList.where((trip){
                  final tripTitle = trip.title.toLowerCase();
                  final tripDescription = trip.description.toLowerCase();  // Convert description to lowercase
                  final query = _searchQuery.toLowerCase(); // Convert query to lowercase
                  // Check if either title or description contains the query
                  return tripTitle.contains(query) || tripDescription.contains(query);

                }).toList();

                if (tripFilterd.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 80,
                          color: Colors.amber,
                        ),
                        const SizedBox(height: 10),
                        Txt(txt: _searchQuery.isEmpty ?"No Trips Found" :"No result found for '$_searchQuery' ",fntSize: 20,fontWeight: FontWeight.bold,)
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
    );
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
