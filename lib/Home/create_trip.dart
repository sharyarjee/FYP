import 'package:easytransit/Home/ride_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CreateTripPage extends StatefulWidget {
  @override
  _CreateTripPageState createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  final TextEditingController _startPointController = TextEditingController();
  final TextEditingController _endPointController = TextEditingController();
  final TextEditingController _tripNameController = TextEditingController();
  final TextEditingController _seatingCapacityController = TextEditingController();
  final TextEditingController _chargesController = TextEditingController();
  String tripType = 'One Time'; // Default value
  final databaseRef = FirebaseDatabase.instance.reference().child("Trip");
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

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
        title: Text('Create Trip'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _startPointController,
                decoration: InputDecoration(
                  labelText: 'Source',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 18.0),
              TextField(
                controller: _endPointController,
                decoration: InputDecoration(
                  labelText: 'Destination',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _tripNameController,
                decoration: InputDecoration(
                  labelText: 'Trip Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _seatingCapacityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Seating Capacity',
                  hintText: '(e.g. 4)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ChoiceChip(
                    label: Text('Daily'),
                    selected: tripType == 'Daily',
                    onSelected: (bool selected) {
                      setState(() {
                        tripType = 'Daily';
                      });
                    },
                  ),
                  ChoiceChip(
                    label: Text('One Time'),
                    selected: tripType == 'One Time',
                    onSelected: (bool selected) {
                      setState(() {
                        tripType = 'One Time';
                      });
                    },
                  ),
                ],
              ),
              if (tripType == 'Daily' || tripType == 'One Time')
                Column(
                  children: [
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: Text('Select Date'),
                        ),
                        SizedBox(width: 16.0),
                        ElevatedButton(
                          onPressed: () => _selectTime(context),
                          child: Text('Select Time'),
                        ),
                      ],
                    ),
                  ],
                ),
              SizedBox(height: 16.0),
              TextField(
                controller: _chargesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Charges (per km)',
                  hintText: '5-15',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50), // Makes the button taller
                ),
                child: Text('Create'),
                onPressed: () {
                  if (_startPointController.text.isEmpty ||
                      _endPointController.text.isEmpty ||
                      _tripNameController.text.isEmpty ||
                      _seatingCapacityController.text.isEmpty ||
                      (tripType != 'Daily' && tripType != 'One Time') ||
                      (_chargesController.text.isEmpty || !_isNumeric(_chargesController.text))) {
                    // Show an error message if any of the required fields are empty or invalid
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Please enter all required fields correctly.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    try {
                      databaseRef.child(DateTime.now().millisecondsSinceEpoch.toString()).set({
                        'id': DateTime.now().millisecondsSinceEpoch.toString(),
                        "source": _startPointController.text.toString(),
                        "destination": _endPointController.text.toString(),
                        "trip name": _tripNameController.text.toString(),
                        "seating capacity": _seatingCapacityController.text.toString(),
                        'trip type': tripType,
                        'date': selectedDate.toLocal().toString(),
                        'time': selectedTime.toString(),
                      });

                      // Show a success message
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Trip Created Successfully'),
                            content: Text('Your trip has been created successfully.'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => RideViewScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } catch (e) {
                      print("Error creating trip: $e");
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  // Helper function to check if a string is numeric
  bool _isNumeric(String value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }
}
