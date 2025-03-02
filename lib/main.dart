import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:opharma/view/auth/localisationPhamacie.dart';
import 'package:opharma/view/auth/pageAuthentificationClient.dart';
import 'package:opharma/view/auth/pageAuthentificationPharma.dart';
import 'package:opharma/view/auth/pagelocale.dart';

import 'package:opharma/view/pharmacie/pageEnregistrement.dart';
import 'package:opharma/view/test.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        primaryColor: Colors.white,
        useMaterial3: false,
        primarySwatch: Colors.blue,
      ),
      home:SignalementApp(),
      //localisationPharmacie(start: LatLng(34.0522, -118.2437),end: LatLng(37.7749, -122.4194)),
    );
  }
}


