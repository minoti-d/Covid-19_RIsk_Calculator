import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


class Risk extends StatefulWidget {

  final String lati;
  final String longi;

  const Risk({Key? key, required this.lati, required this.longi}) : super(key: key);


  @override
  _RiskState createState() => _RiskState();
}

class _RiskState extends State<Risk> {

  late List locData;

  fetchCountryData()async{
    String result;
    var totalConfirmed;
    var totalDeaths;
    var totalRecovered;
    http.Response response = await http.get(Uri.parse('https://raw.githubusercontent.com/IyerShruti/Json/main/India.json'));
    setState(() {

      locData = json.decode(response.body);
    });

    for (var x in locData) {
      for (var y in x["areas"])
        if ((y["lat"].round().toString() == widget.lati) &&
            (y["long"].round().toString() == widget.longi)) {
          result = locData[x]["areas"][y]["id"];
          totalConfirmed = locData[x]["areas"][y]["totalConfirmed"];
          print(totalConfirmed);

          totalDeaths = locData[x]["areas"][y]["totalDeaths"];
          print(totalRecovered);
          totalRecovered = locData[x]["areas"][y]["totalRecovered"];
          print(totalDeaths);
        }
    }

  }



  @override
  void initState() {
    fetchCountryData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Risk Calculator'),

      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Text("Total Confirmed  "),

          ),
          Container(
            child: Text("Total Confirmed  "),

          ),

        ],

      ),
    );
  }
}
