import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TripSearchWidget extends StatefulWidget {
  final Function(String) onSearch;

  const TripSearchWidget({
    super.key,
    required this.onSearch,
  });

  @override
  State<TripSearchWidget> createState() => _TripSearchWidgetState();
}

class _TripSearchWidgetState extends State<TripSearchWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      widget.onSearch(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.poppins(color: Colors.black87),
        decoration: InputDecoration(
          hintText: 'Search for a trip...',
          hintStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade600,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, color: Colors.grey),
            onPressed: () {
              _searchController.clear();
            },
          )
              : null,
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 20.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none, // কোনো বর্ডার থাকবে না
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(
              color: Colors.amber, // ফোকাস করলে অ্যাম্বার রঙ হবে
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}