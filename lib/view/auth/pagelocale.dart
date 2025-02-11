

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import '../../utils/Endpoint.dart';

class PharmacyMapScreen extends StatefulWidget {
  @override
  _PharmacyMapScreenState createState() => _PharmacyMapScreenState();
}

class _PharmacyMapScreenState extends State<PharmacyMapScreen> {
  GoogleMapController? _mapController;
  LocationData? _currentPosition;
  Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initLocationAndFetchPharmacies();
  }

  Future<void> _initLocationAndFetchPharmacies() async {
    await _determinePosition();
    if (_currentPosition != null) {
      await _fetchPharmacies();
    }
    setState(() => _isLoading = false);
  }

  Future<void> _determinePosition() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    _currentPosition = await location.getLocation();
    setState(() {});
  }

  Future<void> _fetchPharmacies() async {
    try {
      final response = await http.get(Uri.parse(Endpoint.baseUrlEnregisterpharmacie));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
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
        markerId: MarkerId(pharmacy['id'].toString()),
        position: LatLng(pharmacy['latitude'], pharmacy['longitude']),
        infoWindow: InfoWindow(title: pharmacy['name']),
      );
    }).toSet();

    setState(() => _markers = newMarkers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pharmacies à proximité")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          if (_currentPosition != null) {
            _mapController!.animateCamera(
              CameraUpdate.newLatLngZoom(
                LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!),
                13.0,
              ),
            );
          }
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            _currentPosition?.latitude ?? 0.0,
            _currentPosition?.longitude ?? 0.0,
          ),
          zoom: 13.0,
        ),
        markers: _markers,
      ),
    );
  }
}
