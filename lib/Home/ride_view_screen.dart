import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'my_profile_detail.dart';
import 'create_ride_detail.dart';

class RideViewScreen extends StatefulWidget {
  @override
  _RideViewScreenState createState() => _RideViewScreenState();
}

class _RideViewScreenState extends State<RideViewScreen> {
  final DatabaseReference tripRef = FirebaseDatabase.instance.ref("Trip");
  final DatabaseReference driverRef = FirebaseDatabase.instance.ref("Driver");

  // Modify the deleteTrip function to accept a nullable string
  void deleteTrip(String? tripKey) {
    if (tripKey != null) {
      tripRef.child(tripKey).remove();
    }
  }

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
        title: Text('Ride View Driver'),
      ),
      body: Column(
        children: [
          Container(
            height: 600,
            child: FirebaseAnimatedList(
              query: tripRef,
              itemBuilder: (context, snapshot, animation, index) {
                // Get the trip key to use it for deletion
                final tripKey = snapshot.key;

                return ListTile(
                  leading: CircleAvatar(),
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
                      // Call the deleteTrip function when the button is pressed
                      deleteTrip(tripKey);
                    },
                    child: Text('Delete'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => UserProfile(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
