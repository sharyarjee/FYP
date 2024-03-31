import 'package:easytransit/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'passenger_screen.dart'; // Import the passenger screen file
import 'ride_view_screen.dart';

class DriverScreen extends StatefulWidget {
  @override
  _DriverScreenState createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  int _currentIndex = 0; // Added to manage the current index of the bottom navigation bar

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
        title: Text('Driver Screen'),
      ),
      drawer: buildDrawer(context), // Use a separate method for the drawer
      body: buildBody(context), // Use a separate method for the body
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
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
        onTap: (index) {
          // Handle item tap to navigate to different sections
          setState(() {
            _currentIndex = index;
          });

          if (index == 0) {
            // Navigate to the home section
            Navigator.pop(context);
          } else if (index == 1) {
            // Navigate to the rating section (you can replace this with your own logic)
            // Navigator.push(...);
          } else if (index == 2) {
            // Navigate to the profile section (you can replace this with your own logic)
            // Navigator.push(...);
          }
        },
      ),
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.yellow, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.yellow, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                ),
              ),
              accountName: Text(
                "Shaheryar",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black, // Set text color to black
                ),
              ),
              accountEmail: Text(
                "sharyarhanif2865@gmail.com",
                style: TextStyle(
                  color: Colors.black, // Set text color to black
                ),
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
            _createDrawerItem(icon: Icons.add_circle, text: 'Create Trip', onTap: () => Navigator.pop(context)),
            _createDrawerItem(icon: Icons.receipt, text: 'Trip Requests', onTap: () => Navigator.pop(context)),
            _createDrawerItem(icon: Icons.edit, text: 'Edit Profile', onTap: () => Navigator.pop(context)),
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
              title: Text('Passenger Mode'),
              value: false, // this should be a state variable
              onChanged: (bool value) {
                // Update the state of the app
                if (value) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => PassengerScreen(),
                  ));
                } else {
                  // Handle turning off Passenger Mode
                }
              },
              secondary: Icon(Icons.person),
            ),
          ],
        ),
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

  Widget buildBody(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(16.0),
      childAspectRatio: 1.2,
      children: [
        _createBoxItem(
          text: 'Ride Share',
          icon: Icons.directions_car,
          onTap: () {
            // Determine whether it's a new user or an existing user here
            bool isNewUser = true; // Replace this with your logic to determine new or existing user
            bool isProfileComplete = true; // Replace this with your logic to determine profile completion
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RideViewScreen(
                  // isNewUser: isNewUser, // Pass the appropriate values here
                  // isProfileComplete: isProfileComplete, // Pass the appropriate values here
                ),
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
          text: 'Bus Schedule',
          icon: Icons.directions_bus,
          onTap: () {
            // Handle the action for Bus Schedule
          },
        ),
      ],
    );
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
}
