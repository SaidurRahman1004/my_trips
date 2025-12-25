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
import '../../widgets/custom_appbar.dart';
import '../../widgets/search_widget.dart';
import '../../widgets/trip_card.dart';
import 'feed_tab.dart';
import 'my_trips_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final DBService _dbService = DBService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: CustomAppBar(title: 'TravelSnap', showProfileIcon: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.amber,
              indicatorWeight: 3,
              labelColor: Colors.amber,
              unselectedLabelColor: Colors.grey,
              labelStyle: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),

              tabs: const [
                Tab(
                  icon: Icon(Icons.public),
                  text: 'Feed',
                ),
                Tab(
                  icon: Icon(Icons.person),
                  text: 'My Trips',
                ),
              ],
            ),
          ),

          //Tab View
          Expanded(child: TabBarView(
            controller: _tabController,
              children: [
                FeedTab(),
                MyTripsTab(),


              ]))
        ],
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
