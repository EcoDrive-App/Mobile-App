import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/components/custom_snack_bar.dart';
import 'package:mobile_app/components/google_map_widget.dart';
import 'package:mobile_app/components/recent_route.dart';
import 'package:mobile_app/user/user_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? _currentPosition;
  String? _currentAddress;
  bool _isLoadingLocation = true;
  StreamSubscription<ServiceStatus>? _locationServiceSubscription;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    bool hasPermission = await _handleLocationPermission();
    if (!hasPermission) {
      _setDefaultPosition();
      return;
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

  Future<void> _setDefaultPosition() async {
    try {
      bool hasPermission = await _handleLocationPermission();
      if (hasPermission) {
        Position? lastKnownPosition = await Geolocator.getLastKnownPosition();

        if (lastKnownPosition != null) {
          setState(() {
            _currentPosition = lastKnownPosition;
            _currentAddress = "";
            _isLoadingLocation = false;
          });
          return;
        }
      }
    } catch (e) {
      // If there's any error, continue to default position
    }

    // If no last known position or no permission, use default position
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
    _setupLocationServiceListener();
  }

  @override
  void dispose() {
    _locationServiceSubscription?.cancel();
    super.dispose();
  }

  void _setupLocationServiceListener() {
    _locationServiceSubscription = Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      if (status == ServiceStatus.enabled) {
        // When location is enabled, try to get the current position
        setState(() => _currentPosition = null);
        _getCurrentLocation();
      } else {
        // When location is disabled, set to default position
        _setDefaultPosition();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      backgroundColor: theme.surface,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "EcoDrive",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: theme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          text: "Buen día, ",
                          style: TextStyle(
                            fontSize: 18,
                            color: theme.onSurface.withValues(alpha: 0.8),
                          ),
                          children: [
                            TextSpan(
                              text: user?.name ?? 'Usuario',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: theme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _currentPosition != null
                      ? KeyedSubtree(
                        key: const ValueKey('map'),
                        child: ClipRRect(
                          child: SizedBox(
                            height: 280,
                            child: MyGoogleMapWidget(initialPosition: _currentPosition!),
                          ),
                        ),
                      )
                      : Container(
                        key: const ValueKey('loading'),
                        height: 280,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 1.5, color: theme.onSurface.withValues(alpha: 0.4)),
                          color: theme.onSurface.withValues(alpha: 0.05),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Theme.of(context).platform == TargetPlatform.iOS
                                ? CupertinoActivityIndicator(radius: 16, animating: true, color: theme.primary)
                                : CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                                  )
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
                        color: theme.surface,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                        border: Border.all(color: theme.outline),
                        boxShadow: [
                          BoxShadow(
                            color: theme.onSurface.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.search, color: theme.primary),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              "¿Hacia dónde?",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Icon(Icons.history, color: theme.primary, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        "Rutas Recientes",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: theme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  RecentRoute(to: "ITM Robledo"),
                  RecentRoute(to: "Castilla"),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}