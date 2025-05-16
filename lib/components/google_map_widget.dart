import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/utils/calculate_area_limit.dart';

class MyGoogleMapWidget extends StatefulWidget {
  final Position initialPosition;

  const MyGoogleMapWidget({super.key, required this.initialPosition});

  @override
  State<MyGoogleMapWidget> createState() => _MyGoogleMapWidgetState();
}

class _MyGoogleMapWidgetState extends State<MyGoogleMapWidget> {
  GoogleMapController? _mapController;
  late LatLng _currentPosition;
  final Set<Marker> _markers = {};
  static BitmapDescriptor _customIcon = BitmapDescriptor.defaultMarker;

  // Map Style
  static String _mapStyle = "";

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _currentPosition = LatLng(
      widget.initialPosition.latitude,
      widget.initialPosition.longitude,
    );

    Future.wait([
      DefaultAssetBundle.of(context)
        .loadString("assets/google_maps_style.json")
        .then((v) => _mapStyle = v),
      BitmapDescriptor.asset(const ImageConfiguration(size: Size(20, 20)), 'assets/current_position.png').then((icon){
        setState(() {
          _customIcon = icon;
        });
      })
    ]).then((_){
      _initializeMap();
    });
  }

  void _initializeMap() {
    _markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: _currentPosition,
        icon: _customIcon,
        anchor: const Offset(0.5, 0.5),
      ),
    );
  }

  void _moveToCurrentPosition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition, 16),
      );
    });
  }

  LatLngBounds get _areaLimit => calculateAreaLimit(_currentPosition, 6.0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        border: Border.all(width: 1.5, color: theme.onSurface.withValues(alpha: 0.4)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
        child: Stack(
          children: [
            GoogleMap(
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
              },
              style: _mapStyle,
              onMapCreated: (controller) {
                _mapController = controller;
                _moveToCurrentPosition();
              },
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 16,
              ),
              minMaxZoomPreference: MinMaxZoomPreference(12, 16),
              cameraTargetBounds: CameraTargetBounds(_areaLimit),
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              markers: _markers,
              compassEnabled: false,
              zoomControlsEnabled: false,
            ),

            Positioned(
              right: 10,
              bottom: 10,
              child: FloatingActionButton.small(
                heroTag: 'location_fab',
                onPressed: _moveToCurrentPosition,
                backgroundColor: theme.primary,
                child: Icon(
                  Icons.my_location,
                  color: theme.onPrimary,
                  size: 20,
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}