import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/components/custom_snack_bar.dart';
import 'package:mobile_app/components/google_map_widget.dart';
import 'package:mobile_app/components/recent_route.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? _currentPosition;
  String? _currentAddress;
  bool _isLoadingLocation = true;

  Future<void> _getCurrentLocation() async {
    if (_currentPosition != null) return;

    setState(() => _isLoadingLocation = true);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
        _setDefaultPosition();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        _setDefaultPosition();
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude
      );

      setState(() {
        _currentPosition = position;
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          _currentAddress = "${place.street}, ${place.locality}";
        }
        _isLoadingLocation = false;
      });

    } catch (e) {
      setState(() {
        _setDefaultPosition();
      });
    }
  }

  void _setDefaultPosition() async {
    final position = Position(
      latitude: 6.2442, longitude: -75.5812,
      timestamp: DateTime.now(),
      accuracy: 0, altitude: 0, heading: 0, speed: 0, altitudeAccuracy: 0, headingAccuracy: 0,
      speedAccuracy: 0, floor: 0, isMocked: false
    );

    setState(() {
      _currentPosition = position;
      _currentAddress = "";
      _isLoadingLocation = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.surface,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text("EcoDrive", style: TextStyle(fontSize: 28)),
                  const SizedBox(height: 10),
                  Text("Buen día, USUARIO", style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _currentPosition != null
                      ? KeyedSubtree(
                        key: const ValueKey('map'),
                        child: ClipRRect(
                          child: MyGoogleMapWidget(initialPosition: _currentPosition!),
                        ),
                      )
                      : Container(
                        key: const ValueKey('loading'),
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                          border: Border.all(width: 1.5, color: theme.onSurface.withValues(alpha: 0.4)),
                          color: theme.onSurface,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ),

                  GestureDetector(
                    onTap: () {
                      if (_isLoadingLocation) {
                        CustomSnackBar.show(context: context, text: 'Buscando tu ubicación', icon: Icons.location_on);
                        return;
                      }

                      Navigator.pushNamed(context, '/destination', arguments: {
                        'currentAddress': _currentAddress,
                        'initialPos': LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.outline),
                        borderRadius: BorderRadius.circular(10),
                        color: theme.surface,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: theme.primary),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text("¿Hacia dónde?", style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text("Rutas Recientes", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 5),
                  RecentRoute(time: "10:00 AM", from: "ITM Fraternidad", to: "ITM Robledo"),
                  RecentRoute(time: "2:40 PM", from: "ITM Robledo", to: "Castilla"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}