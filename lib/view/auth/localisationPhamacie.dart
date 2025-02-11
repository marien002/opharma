import 'dart:async';
import 'dart:convert';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:opharma/view/auth/pageAuthentificationPharma.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';

import '../../const/alertForm.dart';
import '../../const/drawer.dart';
import '../../utils/Endpoint.dart';
import 'localisationPhamacie.dart';

//import 'package:soos_alerts/const/drawer.dart';

class SignalementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignalementPage(),
    );
  }
}

class SignalementPage extends StatefulWidget {

  @override
  _SignalementPageState createState() => _SignalementPageState();
}

class _SignalementPageState extends State<SignalementPage> {
  LatLng? currentPosition;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final MapController _mapController = MapController();
  final Completer<void> _mapReady = Completer<void>();
  List<Marker> markers = [];
  List<Polyline> polylines = [];
  List<Widget> distanceWidgets = [];
  final MapController mapController = MapController();
  Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {

      _initLocationAndFetchPharmacies();


      // _determinePosition();
    });
  }

 getRoute() async {
    Uri url = Uri.parse(Endpoint.baseUrlEnregisterpharmacie);

    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json",
        "User-Agent": "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
      },

    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print ('dataaaaaaaaaaa: $data');
      List<LatLng> route = [];
      if (data['data'].isNotEmpty) {

        // var coordinates = data['data'][0]['geometry']['coordinates'];
        /*  for (var coord in coordinates) {
          route.add(LatLng(coord[1], coord[0]));
        }*/
      }
      return route;
    } else {
     print(response.statusCode);
     print(response.body);
    }
  }

  Future<void> _determinePosition() async {
    // Vérifier les permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    // Récupérer la position actuelle
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition();

      setState(() {
        currentPosition = LatLng(position.latitude, position.longitude);
      });

      // if (!_mapReady.isCompleted) {
      //   await _mapReady.future;
      // }

      if (currentPosition != null) {
        print(" Ma position: ${position.latitude}, ${position.longitude}");
        _mapController.move(currentPosition!, 13.0);

      }
    }
  }

  Future<void> _initLocationAndFetchPharmacies() async {
    await _determinePosition();
    if (currentPosition != null) {
      await _fetchPharmacies();
    }
    setState(() => _isLoading = false);
  }
  Future<void> _fetchPharmacies() async {
    try {
      Uri url = Uri.parse(Endpoint.baseUrlEnregisterpharmacie);

      var response = await http.get(
        url,
        headers: {"Content-Type": "application/json",
          "User-Agent": "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
        },

      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(' position  ::::::::::: ${response.body}');
        _addMarkers(data['data']);
      } else {
        print("Erreur API: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Erreur lors de la récupération des pharmacies: $e");
    }
  }

  void _addMarkers(List pharmacies) {

    Set<Marker> newMarkers = pharmacies.map((pharmacy) {
      return Marker(
        width: 80,
        height: 80,
       point: LatLng(
      pharmacy['latitude'] != null ? double.parse(pharmacy['latitude'].toString()) : 0.0,
      pharmacy['longitude'] != null ? double.parse(pharmacy['longitude'].toString()) : 0.0,
      ),


      child: Icon(Icons.local_pharmacy_sharp, color: Colors.red, size: 40),
      );
    }).toSet();

    setState(() => _markers = newMarkers);
    print(newMarkers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF0D1136),
      body: Stack(
        children: [
          // Affichage de la carte

          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter:
              LatLng(2.3522219, 48.8566969), // Center the map over London
              initialZoom: 9.2,
              onMapReady: () {
                // _mapReady.complete();
                print('Map is ready');
                _determinePosition();
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              ),
              MarkerLayer(
                markers: [
                  if(currentPosition != null)
                    Marker(
                      point: currentPosition!,
                      width: 80,
                      height: 80,
                      child: Icon(Icons.person_pin, color: Colors.red, size: 40),
                    ),
                  ..._markers,
                ],
              ),
            ],
          ),

          if (currentPosition == null)
            Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),

          // En-tête
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  30), // Pour arrondir les coins du container
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 1.0, sigmaY: 1.0), // Paramètre de flou
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B1F4A)
                        .withOpacity(0.2), // Fond semi-transparent
                  ),
                  padding: const EdgeInsets.all(8), // Ajuster l'espacement
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Ouvre le Drawer via la clé globale
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        icon: const Icon(Icons.menu, color: Colors.white),
                      ),
                      Column(
                        children: [
                          const Text(
                            "Opharma",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Footer
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1B1F4A),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search, color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      showMaterialModalBottomSheet(
                        context: context,
                        builder: (context) => SingleChildScrollView(
                          controller: ModalScrollController.of(context),
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Que souhaitez-vous faire ?",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),
                                ListTile(
                                  leading: Icon(Icons.crisis_alert_sharp,
                                      color: Colors.red),
                                  title: Text("Reserver une ordonance"),
                                  onTap: () {
                                    showAlertForm(context);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.call, color: Colors.red),
                                  title: Text("Appeler les urgences"),
                                  onTap: () {
                                    // Logique pour appeler les urgences
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.location_on,
                                      color: Colors.blue),
                                  title: Text("Localiser une pharmacie"),
                                  onTap: () {
                                    // Logique pour partager la position
                                  },
                                ),
                                ListTile(
                                  leading:
                                  Icon(Icons.close, color: Colors.grey),
                                  title: Text("Fermer"),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(50, 190, 166, 1), // Couleur vive pour attirer l'attention
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.6),
                            blurRadius: 6,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.miscellaneous_services_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8, left: 8),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  pageAuthentificationPharma()
                          ), // Remplacez ProfilePage par le nom de votre page de destination
                        );
                      },
                      icon: const Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: DrawerFb1(),
    );
  }
}