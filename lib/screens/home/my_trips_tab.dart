import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_trips/models/trip_model.dart';
import 'package:my_trips/widgets/CenterCircularProgressIndicator.dart';
import 'package:my_trips/widgets/CustomText.dart';
import 'package:my_trips/widgets/custo_snk.dart';
import 'package:my_trips/widgets/custom_button.dart';
import 'package:my_trips/widgets/custom_text_field.dart';
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Txt(
            txt: 'My Travel Memories',
            fntSize: 24,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 5),
          FutureBuilder<DateTime?>(
            future: _dbService.getLastUpdatedDate(currentuser!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                String formattedLastDate = DateFormat(
                  'dd/MM/yyyy',
                ).format(snapshot.data!);
                return Txt(
                  txt: 'Last Updated: $formattedLastDate',
                  fntSize: 15,
                  color: Colors.grey,
                );
              } else {
                return const SizedBox();
              }
            },
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

                if (tripsList.isEmpty) {
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
                          txt: 'No Trips Found',
                          fntSize: 20,
                          fontWeight: FontWeight.bold,
                        ),

                        const SizedBox(height: 10),
                        Txt(txt: 'Add your first travel memory!', fntSize: 14),
                      ],
                    ),
                  );
                }

                //if search bax has any content then try to filter otherwise show all
                final tripFilterd = tripsList.where((trip) {
                  final tripTitle = trip.title.toLowerCase();
                  final tripDescription = trip.description
                      .toLowerCase(); // Convert description to lowercase
                  final query = _searchQuery
                      .toLowerCase(); // Convert query to lowercase
                  // Check if either title or description contains the query
                  return tripTitle.contains(query) ||
                      tripDescription.contains(query);
                }).toList();

                if (tripFilterd.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 80, color: Colors.amber),
                        const SizedBox(height: 10),
                        Txt(
                          txt: _searchQuery.isEmpty
                              ? "No Trips Found"
                              : "No result found for '$_searchQuery' ",
                          fntSize: 20,
                          fontWeight: FontWeight.bold,
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
                      builder: (BuildContext context, double value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: TripCard(
                        tripModel: AccesstripList,
                        onDelete: () {
                          _showDeleteDialog(context, AccesstripList.id);
                        },
                        onEdit: () {
                          _showEditingDialog(context, AccesstripList);
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

  //Edit Dialog
  void _showEditingDialog(BuildContext context, TripModel trip) {
    final TextEditingController _titleCtrl = TextEditingController(
      text: trip.title,
    );
    final TextEditingController _descriptionCtrl = TextEditingController(
      text: trip.description,
    );
    bool isPublic = trip.isPublic;

    showModalBottomSheet(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (_, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Txt(txt: 'Edit Trip', fntSize: 22, fontWeight: FontWeight.bold),
                const SizedBox(height: 20),

                // Title Input
                Txt(txt: 'Title', fntSize: 16, fontWeight: FontWeight.bold),
                const SizedBox(height: 5),
                CustomTextField(
                  controller: _titleCtrl,
                  lableText: 'Title',
                  hintText: 'Enter New Title',
                ),
                const SizedBox(height: 15),

                // Description Input
                Txt(
                  txt: 'Description',
                  fntSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 5),
                CustomTextField(
                  controller: _descriptionCtrl,
                  lableText: 'Description',
                  hintText: 'Enter New Description',
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Txt(txt: isPublic ? 'Public Post' : 'Private Post'),
                    Switch(value: isPublic,
                        activeThumbColor: Colors.amber,
                        onChanged: (val){
                      setModalState(() {
                        isPublic = val;
                      });

                    }),
                  ],
                ),
                const SizedBox(height: 15),
                //Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(buttonName: 'Update Trip', onPressed: () async{
                    final currentuser = FirebaseAuth.instance.currentUser;
                    final String currentName = currentuser?.displayName ?? trip.userName;
                    final String? currentPhoto = currentuser?.photoURL ?? trip.userPhoto;
                    final updateTrip = TripModel(
                      id: trip.id,
                      userId: trip.userId,
                      title: _titleCtrl.text.trim(),
                      description: _descriptionCtrl.text.trim(),
                      location: trip.location,
                      latitude: trip.latitude,
                      longitude: trip.longitude,
                      imageUrl: trip.imageUrl,
                      date: trip.date,
                      isPublic: isPublic,
                      userName: currentName,
                      userPhoto: currentPhoto,
                      likesCount: trip.likesCount,
                      commentsCount: trip.commentsCount,
                    );
                    Navigator.pop(context);
                    try{
                      await _dbService.updateTripData(updateTrip);
                      if(mounted){
                        mySnkmsg('Trip Updated Successfully', context);
                      }
                    }catch(e){
                      if(mounted){
                        mySnkmsg(e.toString(), context);
                      }

                    }

                  }),
                ),
                const SizedBox(height: 20),



              ],
            ),
          );
        },
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
