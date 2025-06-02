import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_app/components/location_warning.dart';
import 'package:mobile_app/components/navbar.dart';
import 'package:mobile_app/pages/home_page.dart';
import 'package:mobile_app/pages/points_page.dart';
import 'package:mobile_app/pages/profile_page.dart';

class RoutesPage extends StatefulWidget {
  const RoutesPage({super.key});

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> with AutomaticKeepAliveClientMixin {
  int _currentIndex = 1;
  bool _isLocationEnabled = true;
  StreamSubscription<ServiceStatus>? _locationServiceSubscription;
  final List<Widget> _pages = [
    PointsPage(),
    HomePage(),
    ProfilePage(),
  ];

  @override
  bool get wantKeepAlive => true;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkLocationService();
    _setupLocationServiceListener();
  }

  @override
  void dispose() {
    _locationServiceSubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      _isLocationEnabled = serviceEnabled;
    });
  }

  void _setupLocationServiceListener() {
    _locationServiceSubscription = Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      setState(() {
        _isLocationEnabled = status == ServiceStatus.enabled;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          // Main Content
          Positioned.fill(
            child: IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
          ),

          // Floating navbar
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: CustomNavbar(
              currentIndex: _currentIndex,
              onTap: _onTabSelected,
            ),
          ),

          // Location warning (now on top of navbar)
          if (!_isLocationEnabled)
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: const LocationWarning(),
            ),
        ],
      ),
    );
  }
}