import 'package:flutter/material.dart';
import 'package:opharma/view/pharmacie/pageEnregistrement.dart';
import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';

import '../../controlers/controler_client.dart';
import '../../controlers/controler_pharmacie.dart';
import '../../controlers/controllerAuth.dart';
import 'package:opharma/elper/navigation.dart';
import '../componentGenerale/ButtonCostom.dart';
import '../componentGenerale/Combobox.dart';
import '../componentGenerale/InputCostom.dart';
import '../componentGenerale/dialogue.dart';
import '../componentGenerale/entete.dart';
import '../componentGenerale/messageFlache.dart';
import '../leyouts/base.dart';
import 'component/Element.dart';
import 'component/blockAuth.dart';
import 'component/blockInt.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
//import 'package:eboodbank_app/gestionStocks/business/model/banque/BanqueModele.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;


class localisationPharmacie extends StatelessWidget {
  final LatLng start;
  final LatLng end;

  localisationPharmacie({required this.start, required this.end});

  double calculateDistance() {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    double distance = calculateDistance();
    return Container(
      margin: EdgeInsets.all(50),
      child: Positioned(
        left: (start.longitude + end.longitude) / 2,
        top: (start.latitude + end.latitude) / 2,
        child: Container(
          padding: EdgeInsets.all(4.0),
          color: Colors.white,
          child: Text(
            'Distance: ${distance.toStringAsFixed(2)} m',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class LocalisationBanquePage extends ConsumerStatefulWidget {
  final List<BanqueModele> bloodBanks;

  LocalisationBanquePage({required this.bloodBanks});

  @override
  ConsumerState<LocalisationBanquePage> createState() =>
      _LocalisationBanquePageState();
}

class BanqueModele {

}

class _LocalisationBanquePageState
    extends ConsumerState<LocalisationBanquePage> {
  List<Marker> markers = [];
  List<Polyline> polylines = [];
  List<Widget> distanceWidgets = [];
  LatLng? currentPosition;
  final MapController mapController = MapController();

  Future<LatLng?> _getCurrentLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return LatLng(position.latitude, position.longitude);
    } else {
      return null;
    }
  }

  Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
    final response = await http.get(
      Uri.parse(
          'http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?geometries=geojson'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<LatLng> route = [];
      if (data['routes'].isNotEmpty) {
        var coordinates = data['routes'][0]['geometry']['coordinates'];
        for (var coord in coordinates) {
          route.add(LatLng(coord[1], coord[0]));
        }
      }
      return route;
    } else {
      throw Exception('Failed to load route');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var positionPhone = await _getCurrentLocation();
      currentPosition = positionPhone;

      markers.add(Marker(
        point: positionPhone ?? const LatLng(-4.4419, 15.2663),
        width: 40.0,
        height: 40.0,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromRGBO(50, 190, 166, 1),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(Icons.person,
              color: Colors.white, size: 23.0),
        ),
      ));
/*
      for (var bank in widget.bloodBanks) {
        var bankPosition = LatLng(
          double.tryParse(bank.latitude.toString()) ?? 0.0,
          double.tryParse(bank.longitude.toString()) ?? 0.0,
        );

        markers.add(Marker(
          point: bankPosition,
          width: 40.0,
          height: 40.0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.redAccent,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.bloodtype, color: Colors.white, size: 23.0),
          ),
        ));

        if (currentPosition != null) {
          List<LatLng> route = await getRoute(currentPosition!, bankPosition);
          if (route.isNotEmpty) {
            polylines.add(Polyline(
              points: route,
              strokeWidth: 4.0,
              color: Colors.blue,
            ));

            // Utilisez le widget de distance
            distanceWidgets.add(
                localisationPharmacie(start: currentPosition!, end: bankPosition));
          }
        }
      }*/

      if (currentPosition != null) {
        mapController.move(currentPosition!, 15.0);
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: currentPosition ?? const LatLng(-4.4419, 15.2663),
              initialZoom: 28.0,
              minZoom: 12.0,
              maxZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'dev.fleatet.flutter_map.example',
              ),
              MarkerLayer(markers: markers),
              PolylineLayer(polylines: polylines),
            ],
          ),
          ...distanceWidgets, // Ajoutez les widgets de distance ici
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mapController.move(
              currentPosition ?? const LatLng(-4.4419, 15.2663), 12.0);
        },
        child: Icon(
          Icons.my_location,
          color: Colors.white,
        ),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}








