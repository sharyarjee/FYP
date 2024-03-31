import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'appconstant.dart';

class CreateRideScreen extends StatefulWidget {
  @override
  _CreateRideScreenState createState() => _CreateRideScreenState();
}

class _CreateRideScreenState extends State<CreateRideScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 32, 32),
        title: const Text('Flutter MapBox'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(30.3753, -69.3451),
          initialZoom: 9.2,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://api.mapbox.com/styles/v1/sherryblueberry/clrf2w49y00bp01pf35wt9af4/wmts?access_token=pk.eyJ1Ijoic2hlcnJ5Ymx1ZWJlcnJ5IiwiYSI6ImNscmYyc3dlNzAwdjkyam9idnRzejJqYzcifQ.la3L6E7CERQFHmIpFXVeXg',
            userAgentPackageName: 'com.example.app',
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
