import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class RiskChecker extends StatelessWidget {

  String location = "Null, Press Button";
  String Address = "search";

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;


    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Coordinate Points',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10,),
            Text(
              location,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 10,),
            Text(
              'ADDRESS',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            SizedBox(height: 10,),
            Text(
              '${Address}',
              style: TextStyle(fontSize: 18),

            ),
            ElevatedButton(onPressed: () async {
              Position  position = await _determinePosition();
              print(position.latitude);
              print(position.longitude);
              location = 'Lat: ${position.latitude}, Long: ${position.longitude}';


            }, child: Text('Get Location'))
          ],
        ),
      ),
    );
  }
}

