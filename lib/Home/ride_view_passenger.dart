import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'my_profile_detail.dart';
import 'create_ride_detail.dart';

class RideViewPassenger extends StatefulWidget {
  @override
  _RideViewScreenState createState() => _RideViewScreenState();
}

class _RideViewScreenState extends State<RideViewPassenger> {
  final auth = FirebaseDatabase.instance;
  final DatabaseReference tripRef = FirebaseDatabase.instance.reference().child("Trip");
  final DatabaseReference driverRef = FirebaseDatabase.instance.reference().child("Driver");
  bool isNewUser = false;
  bool isProfileComplete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.yellow, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
            ),
          ),
        ),
        title: Text('Ride View Passenger'),
      ),

      body: Column(
        children: [
          Container(
            height: 600, // Set a specific height or use MediaQuery to calculate height dynamically.
            child: FirebaseAnimatedList(
              query: tripRef,
              itemBuilder: (context, snapshot, animation, index) {
                return ListTile(
                  leading: CircleAvatar(
                    // Assuming 'driverImage' is a URL to the driver's image in your database
                    // backgroundImage: NetworkImage(snapshot.child("driverImage").value.toString()),
                  ),
                  title: Text(snapshot.child("trip name").value.toString()),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pick up: " + snapshot.child("source").value.toString()),
                      Text("Drop off: " + snapshot.child("destination").value.toString()),
                      Text("Departure Time: " + snapshot.child("time").value.toString()),
                      Text("Date: " + snapshot.child("date").value.toString()),
                      Text("Available Seats: " + snapshot.child("seating capacity").value.toString()),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Handle the booking action
                    },
                    child: Text('BOOK'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
