import 'package:covid_app/datasource.dart';
import 'package:covid_app/homepage.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: primaryBlack
    ),
    home: HomePage()),
    );
}