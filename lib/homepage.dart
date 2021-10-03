import 'dart:convert';

import 'package:covid_app/risk.dart';
import 'package:covid_app/riskcal.dart';
import 'package:covid_app/widgets/mosteffectedcountries.dart';
import 'package:covid_app/widgets/worldwidepanel.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;

import 'datasource.dart';

class HomePage extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {

  String location = "Null, Press Button";
  String Address = "search";
  late String lati;
  late String longi;

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


  late Map worldData;
  fetchWorldWideData()async{
    http.Response response = await http.get(Uri.parse('https://disease.sh/v3/covid-19/all'));
    setState(() {
      worldData = json.decode(response.body);
    });
  }

  late List countryData;
  fetchCountryData()async{
    http.Response response = await http.get(Uri.parse('https://disease.sh/v3/covid-19/countries'));
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  @override
  void initState() {
    fetchWorldWideData();
    fetchCountryData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('COVID-19 TRACKER',),
      ),
      body: SingleChildScrollView(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 100,
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            color:Colors.orange[100],
            child: Text(DataSource.quote, style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.bold, fontSize: 16)),
      ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Worldwide', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  Container(
                    decoration: BoxDecoration(
                    color: primaryBlack,
                    borderRadius: BorderRadius.circular(15)
                    ),
                    padding: EdgeInsets.all(10),
                    child:
                    Text('Regional', style: TextStyle(fontSize:16, fontWeight: FontWeight.bold, color: Colors.white),),),

                ],
              )

            ),
            worldData==null?CircularProgressIndicator():WorldwidePanel(worldData: worldData),
          SizedBox(height: 20,),
          Padding(

            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text('Most Affected Countries', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
          ),
          SizedBox(height: 10,),
          countryData==null?CircularProgressIndicator():MostAffectedPanel(countryData: countryData),
          Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
                alignment: Alignment.center,
              ),

              onPressed: () async {
                Position  position = await _determinePosition();
                print(position.latitude.round());
                print(position.longitude.round());
                location = 'Lat: ${position.latitude}, Long: ${position.longitude}';

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Risk(
                    lati: (position.latitude).round().toString(),
                    longi: (position.longitude).round().toString(),
                  ),
                ));

              },
            child: Text('Risk Checker'),),
          )

        ],
      )),

    );
  }
}
