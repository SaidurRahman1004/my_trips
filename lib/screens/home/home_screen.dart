import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_trips/models/trip_model.dart';
import 'package:my_trips/widgets/CenterCircularProgressIndicator.dart';
import '../../services/auth_service.dart';
import '../../services/db_service.dart';
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
      appBar: AppBar(
        leading: FlutterLogo(),
        title: const Text("My Trips"),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.amber.shade100,
            child: IconButton(
              onPressed: onProfileRouter,
              icon: Icon(Icons.person),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AuthService().logOut(),
          ),
        ],
      ),
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
            Text(
              "Last Uodated: 12/12/2023",
              style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey),
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
                          Icon(Icons.trip_origin, size: 80,
                              color: Colors.amber),
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
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                              )),


                        ],
                      ),

                    );
                  }

                  return ListView.builder(
                      itemCount: tripsList.length,
                      itemBuilder: (context, index) {
                        final tripModel = tripsList[index];
                        return TripCard(
                            tripModel: tripModel, onDelete: () async{


                        });
                      });
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _onAddTrip,
        child: const Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
    );
  }

  void onProfileRouter() {}

  void _onAddTrip() {}


}
