// import 'package:demo_project1/driver_screen.dart';
import 'package:easytransit/Home/ride_view_passenger.dart';
import 'package:easytransit/Home/ride_view_screen.dart';

import 'driver_screen.dart';
import 'package:easytransit/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PassengerScreen extends StatefulWidget {
  final auth=FirebaseAuth.instance;


  final ref = FirebaseDatabase.instance.ref('Users');
   @override
  _PassengerScreenState createState() => _PassengerScreenState();
}

class _PassengerScreenState extends State<PassengerScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(), // Example: Home screen
    RatingScreen(), // Example: Rating screen
    ProfileScreen(), // Example: Profile screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _createBoxItem({required String text, required IconData icon, required GestureTapCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48.0, color: Colors.black),
            SizedBox(height: 8.0),
            Text(
              text,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final yellowGradient = LinearGradient(
      colors: [Colors.yellow, Colors.white],
      begin: Alignment.topLeft,
      end: Alignment.topRight,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: yellowGradient,
          ),
        ),
        title: Text('Passenger Screen'),
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: yellowGradient,
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  gradient: yellowGradient,
                ),
                accountName: Text(
                  "shaheryar hanif",
                  style: TextStyle(color: Colors.black), // Set text color to black
                ),
                accountEmail: Text(
                  "sharyarhanif2865@gmail.com",
                  style: TextStyle(color: Colors.black), // Set text color to black
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Text(
                    'S',
                    style: TextStyle(fontSize: 40.0, color: Colors.white),
                  ),
                ),
              ),

              _createDrawerItem(icon: Icons.home, text: 'Home', onTap: () => Navigator.pop(context)),
              _createDrawerItem(icon: Icons.receipt, text: 'Trip Requests', onTap: () => Navigator.pop(context)),
              _createDrawerItem(icon: Icons.edit, text: 'Edit Profile', onTap: () => Navigator.pop(context)),
              // Modify the "Logout" item in the drawer to log out the user and navigate to the login page
              _createDrawerItem(icon: Icons.exit_to_app, text: 'Logout', onTap: () async {

                // For example, you can use FirebaseAuth to sign the user out:
                await FirebaseAuth.instance.signOut();

                // 2. After logout, navigate to the login page
                Navigator.pop(context); // Close the drawer
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => LoginPage(), // Navigate to the LoginPage
                ));
              }),


              _createDrawerItem(icon: Icons.security, text: 'Privacy Policy', onTap: () => Navigator.pop(context)),
              SwitchListTile(
                title: Text('Driver Mode'),
                value: false, // this should be a state variable
                onChanged: (bool value) {
                  // Update the state of the app
                  if (value) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => DriverScreen(),
                    ));
                  } else {
                    // Handle turning off Passenger Mode
                  }
                },
                secondary: Icon(Icons.directions_car),
              ),
            ],
          ),
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        childAspectRatio: 1.2,
        children: [
          _createBoxItem(
            text: 'Ride Book',
            icon: Icons.directions_car,
            onTap: () {
              // Determine whether it's a new user or an existing user here
              bool isNewUser = true; // Replace this with your logic to determine new or existing user
              bool isProfileComplete = true; // Replace this with your logic to determine profile completion
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RideViewPassenger()
                    // isNewUser: isNewUser, // Pass the appropriate values here
                    // isProfileComplete: isProfileComplete, // Pass the appropriate values here
                  ),

              );

            },

          ),
          _createBoxItem(
            text: 'Parcel Delivery',
            icon: Icons.local_shipping,
            onTap: () {
              // Handle the action for Parcel Delivery
            },
          ),
          _createBoxItem(
            text: 'Emergency Service',
            icon: Icons.local_hospital,
            onTap: () {
              // Handle the action for Emergency Service
            },
          ),
          _createBoxItem(
            text: 'View Bus Schedule',
            icon: Icons.directions_bus,
            onTap: () {
              // Handle the action for View Bus Schedule
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Rating',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.yellow,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _createDrawerItem({required IconData icon, required String text, required GestureTapCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Home Screen Content',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class RatingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Rating Screen Content',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Profile Screen Content',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
