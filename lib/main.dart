import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nav_app/base/bottom_nav.dart';
import 'package:nav_app/services/location_service.dart';
import 'package:nav_app/widgets/city_dropdown.dart' as cityWidget;  
import 'package:nav_app/models/city_model.dart';  
import 'dart:math';
import 'dart:async'; 

void main() {
  runApp(DistanceApp());
}

class DistanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Distance App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocationService _locationService = LocationService();
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(0, 0);
  bool _loading = true;

  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();

    // Start position updates using Geolocator's stream
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10, // Update only if position changes by at least 10 meters
      ),
    ).listen((Position position) {
      // Update the current position
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _loading = false;
      });

      // Optionally move the map camera to the new position
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(_currentPosition),
      );
    });
  }

  @override
  void dispose() {
    // Cancel the stream subscription when the widget is disposed
    _positionStreamSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  // Define the list of cities
  final List<City> _cities = [
    City(name: 'Chicago', coordinates: const LatLng(41.8781, -87.6298)),
    City(name: 'New York', coordinates: const LatLng(40.7128, -74.0060)),
    City(name: 'Paris', coordinates: const LatLng(48.8566, 2.3522)),
    City(name: 'Singapore', coordinates: const LatLng(1.3521, 103.8198)),
  ];

  // Transportation speeds 
  final Map<int, double> _speeds = {
    0: 15,  // Bike speed
    1: 5,   // Walk speed
    2: 60,  // Drive speed
    3: 800, // Fly speed
  };

  // city and mode
  City? _selectedCity;
  int _selectedMode = 2; // Default mode: Drive
  double? _distanceInKm;
  double? _estimatedTimeInHours;

  Future<void> _showLocationDialog(String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onCitySelected(City? city) {
    setState(() {
      _selectedCity = city;
    });

    if (city != null) {
      double distance = _locationService.calculateDistance(_currentPosition, city.coordinates);
      double estimatedTime = distance / _speeds[_selectedMode]!;

      setState(() {
        _distanceInKm = distance;
        _estimatedTimeInHours = estimatedTime;
      });

      _mapController?.animateCamera(CameraUpdate.newLatLng(city.coordinates));
    }
  }

  void _onModeSelected(int modeIndex) {
    setState(() {
      _selectedMode = modeIndex;

      if (_selectedCity != null) {
        double distance = _locationService.calculateDistance(_currentPosition, _selectedCity!.coordinates);
        double estimatedTime = distance / _speeds[_selectedMode]!;

        setState(() {
          _distanceInKm = distance;
          _estimatedTimeInHours = estimatedTime;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  flex: 11,
                  child: GoogleMap(
                    onMapCreated: (controller) {
                      _mapController = controller;
                      _mapController?.animateCamera(
                        CameraUpdate.newLatLngZoom(_currentPosition, 10),
                      );
                    },
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition,
                      zoom: 10,
                    ),
                    markers: _createMarkers(),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
                ),
                Expanded(
                flex: 1,
                child: cityWidget.CityDropdown(
                  cities: _cities,
                  selectedCity: _selectedCity,
                  onCitySelected: _onCitySelected,
                ),
              ),
                _buildDistanceInfo(),
              ],
            ),
      bottomNavigationBar: BottomNav(
        selectedIndex: _selectedMode,
        onItemSelected: _onModeSelected,
      ),
    );
  }

  Set<Marker> _createMarkers() {
    Set<Marker> markers = {};

    markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: _currentPosition,
        infoWindow: const InfoWindow(title: 'Your Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    );

    if (_selectedCity != null) {
      markers.add(
        Marker(
          markerId: MarkerId(_selectedCity!.name),
          position: _selectedCity!.coordinates,
          infoWindow: InfoWindow(title: _selectedCity!.name),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    }

    return markers;
  }

  Widget _buildDistanceInfo() {
    if (_selectedCity == null) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Distance to ${_selectedCity!.name}: ${_distanceInKm!.toStringAsFixed(2)} km',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            'Estimated Travel Time: ${_estimatedTimeInHours!.toStringAsFixed(2)} hours',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  String _getModeLabel(int modeIndex) {
    switch (modeIndex) {
      case 0:
        return 'Bike';
      case 1:
        return 'Walk';
      case 2:
        return 'Drive';
      case 3:
        return 'Fly';
      default:
        return 'Drive';
    }
  }
}
