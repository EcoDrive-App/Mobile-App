import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/components/custom_snack_bar.dart';
import 'package:mobile_app/components/google_map_widget.dart';
import 'package:mobile_app/components/permission_warning.dart';
import 'package:mobile_app/components/recent_route.dart';
import 'package:mobile_app/components/recommendation_card.dart';
import 'package:mobile_app/preferences/location_provider.dart';
import 'package:mobile_app/types/recommendation.dart';
import 'package:mobile_app/preferences/user_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? _currentPosition;
  String? _currentAddress;
  StreamSubscription<ServiceStatus>? _locationServiceSubscription;

  bool _isLoadingLocation = true;
  bool _hasLocationPermission = true;
  bool _hasAskedPermission = false;

  final Recommendation _recommendation = Recommendation(
    title: 'Conduce de manera eficiente',
    description: 'Mantén una velocidad constante y evita aceleraciones bruscas para reducir el consumo de combustible y las emisiones de CO2.',
    imageUrl: 'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
  );

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (_hasAskedPermission && permission == LocationPermission.denied) {
      setState(() => _hasLocationPermission = false);
      return false;
    }

    if (permission == LocationPermission.denied && !_hasAskedPermission) {
      _hasAskedPermission = true;
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _hasLocationPermission = false);
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _hasLocationPermission = false);
      return false;
    }

    setState(() => _hasLocationPermission = true);
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

      if (mounted) {
        final locationProvider = Provider.of<LocationProvider>(context, listen: false);
        await locationProvider.savePosition(position);
      }

      setState(() {
        _currentPosition = position;
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          _currentAddress = "${place.street}, ${place.locality}";
        }
        _isLoadingLocation = false;
      });

    } catch (e) {
      if (mounted){
        setState(() {
          _setDefaultPosition();
        });
      }
    }
  }

  Future<void> _setDefaultPosition() async {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    Position? lastKnownPosition = await locationProvider.loadLastKnownPosition();

    if (lastKnownPosition != null) {
      setState(() {
        _currentPosition = lastKnownPosition;
        _currentAddress = "";
        _isLoadingLocation = false;
      });
      return;
    }

    setState(() {
      _currentPosition = locationProvider.getDefaultPosition();
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
        setState(() => _currentPosition = null);
        _getCurrentLocation();
      } else {
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 62),
                    Text("EcoDrive",
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: theme.primary,),
                    ),
                    const SizedBox(height: 8),
                    Text.rich(
                      TextSpan(text: "Buen día, ",
                        style: TextStyle(fontSize: 18, color: theme.onSurface.withValues(alpha: 0.8),),
                        children: [
                          TextSpan(
                            text: user?.name ?? 'Usuario',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.primary,),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                if (!_hasLocationPermission)
                  PermissionWarning(onPermissionGranted: () async {
                    _getCurrentLocation();
                  }),


                if (_hasLocationPermission) ...[
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
                          child: CircularProgressIndicator.adaptive(),
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
                ],

                const SizedBox(height: 32),
                Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: theme.primary, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      "Consejo del día",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: theme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                RecommendationCard(
                  recommendation: _recommendation,
                  onTap: () {
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}