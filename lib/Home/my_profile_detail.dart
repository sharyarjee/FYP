import 'dart:io';

import 'package:easytransit/Home/create_trip.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final vehicleNameController = TextEditingController();
  final vehicleNumberController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref("Driver");
  String selectedVehicleType = 'Vehicle Type';
  String? imageUrl;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickAndUploadImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) {
      return;
    }

    final File imageFile = File(pickedImage.path);
    final Reference storageRef = FirebaseStorage.instance.ref().child('profile_images').child('${DateTime.now()}.jpg');

    await storageRef.putFile(imageFile);
    final String downloadURL = await storageRef.getDownloadURL();

    setState(() {
      imageUrl = downloadURL;
    });
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
        title: Text('My Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: pickAndUploadImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: imageUrl != null
                    ? NetworkImage(imageUrl!)
                    : null,
                child: imageUrl == null
                    ? Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.grey.shade800,
                )
                    : null,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name*',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone no*',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            TextField(
              controller: vehicleNameController,
              decoration: InputDecoration(
                labelText: 'Vehicle Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: vehicleNumberController,
              decoration: InputDecoration(
                labelText: 'Vehicle No',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedVehicleType = 'Bike';
                    });
                  },
                  child: Text('Bike'),
                  style: ElevatedButton.styleFrom(
                    primary: selectedVehicleType == 'Bike'
                        ? Colors.yellow
                        : null,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedVehicleType = 'Car';
                    });
                  },
                  child: Text('Car'),
                  style: ElevatedButton.styleFrom(
                    primary: selectedVehicleType == 'Car'
                        ? Colors.yellow
                        : null,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedVehicleType = 'SUV';
                    });
                  },
                  child: Text('SUV'),
                  style: ElevatedButton.styleFrom(
                    primary: selectedVehicleType == 'SUV'
                        ? Colors.yellow
                        : null,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
              ),
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty &&
                    selectedVehicleType != 'Vehicle Type') {
                  await databaseRef
                      .child(DateTime.now().millisecondsSinceEpoch.toString())
                      .set({
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'name': nameController.text.toString(),
                    'phone no': phoneController.text.toString(),
                    'vehicle Name': vehicleNameController.text.toString(),
                    'vehicle no': vehicleNumberController.text.toString(),
                    'vehicle type': selectedVehicleType,
                    'profile_image_url': imageUrl, // Store the image URL
                  });

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Profile Created Successfully'),
                        content: Text('Your profile has been created successfully.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => CreateTripPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Please enter all required fields and select a vehicle type.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Save'),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
