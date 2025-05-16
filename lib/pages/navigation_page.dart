import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/components/vehicle_selector.dart';
import 'package:mobile_app/types/types.dart';
import 'package:mobile_app/utils/calculate_area_limit.dart';

class NavigationPage extends StatefulWidget {
  final String currentAddress;
  final LatLng currentPos;

  final String destinationAddress;
  final LatLng destinationPos;

  const NavigationPage({
    super.key,
    required this.currentAddress,
    required this.currentPos,
    required this.destinationAddress,
    required this.destinationPos
  });

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  late GoogleMapController _mapController;
  final List<VehicleType> _vehicleTypes = [
    VehicleType('Carro', Icons.directions_car_rounded, 3, 1),
    VehicleType('Moto', Icons.motorcycle_rounded, 1, 1),
    VehicleType('Bicicleta', Icons.directions_bike_rounded, 1, 1),
    VehicleType('Bus', Icons.directions_bus_rounded, 1, 1),
  ];

  VehicleType? _selectedVehicle;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  final PolylinePoints _polylinePoints = PolylinePoints();

  static BitmapDescriptor _originIcon = BitmapDescriptor.defaultMarker;
  static BitmapDescriptor _finalIcon = BitmapDescriptor.defaultMarker;

  // Map Style
  static String _mapStyle = "";

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.wait([
      DefaultAssetBundle.of(context).loadString("assets/google_maps_style.json")
        .then((v) => _mapStyle = v),
      BitmapDescriptor.asset(const ImageConfiguration(size: Size(20, 20)), 'assets/current_position.png').then((icon){
        setState(() {
          _originIcon = icon;
        });
      }),
      BitmapDescriptor.asset(const ImageConfiguration(size: Size(20, 20)), 'assets/final_position.png').then((icon){
        setState(() {
          _finalIcon = icon;
        });
      })
    ]).then((_){
          _initializeMapData();
          _getPolyline();
    });
  }

  void _initializeMapData() {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('origin'),
          position: widget.currentPos,
          icon: _originIcon,
          anchor: const Offset(0.5, 0.5),
        ),
        Marker(
          markerId: const MarkerId('destination'),
          position: widget.destinationPos,
          icon: _finalIcon,
          anchor: const Offset(0.5, 0.5),
        ),
      };
    });
  }

  Future<void> _getPolyline() async {
    final result = await _polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: dotenv.get('GOOGLE_MAPS_API_KEY'),
      request: PolylineRequest(
        origin: PointLatLng(widget.currentPos.latitude, widget.currentPos.longitude),
        destination: PointLatLng(widget.destinationPos.latitude, widget.destinationPos.longitude),
        mode: TravelMode.driving,
        alternatives: false
      ),
    );

    if (result.points.isNotEmpty) {
      final points = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      setState(() {
        _polylines = {
          Polyline(
            polylineId: const PolylineId('route'),
            points: points,
            color: Color(0xFF333D29),
            width: 5,
          ),
        };
      });
      _fitToBounds();
    }
  }

  // calcule point between current and desintation pos
  LatLngBounds _calculateBounds() {
    return LatLngBounds(
      southwest: LatLng(
        widget.currentPos.latitude < widget.destinationPos.latitude
            ? widget.currentPos.latitude
            : widget.destinationPos.latitude,
        widget.currentPos.longitude < widget.destinationPos.longitude
            ? widget.currentPos.longitude
            : widget.destinationPos.longitude,
      ),
      northeast: LatLng(
        widget.currentPos.latitude > widget.destinationPos.latitude
            ? widget.currentPos.latitude
            : widget.destinationPos.latitude,
        widget.currentPos.longitude > widget.destinationPos.longitude
            ? widget.currentPos.longitude
            : widget.destinationPos.longitude,
      ),
    );
  }

  Future<void> _fitToBounds() async {
    final bounds = _calculateBounds();
    final cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 100);
    await _mapController.animateCamera(cameraUpdate);
  }

  LatLngBounds get _areaLimit => calculateAreaLimit(LatLng(
    (widget.currentPos.latitude + widget.destinationPos.latitude) / 2,
    (widget.currentPos.longitude + widget.destinationPos.longitude) / 2,
    ), 6.0);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            style: _mapStyle,
            onMapCreated: (controller) {
              _mapController = controller;
              _fitToBounds();
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(
                (widget.currentPos.latitude + widget.destinationPos.latitude) / 2,
                (widget.currentPos.longitude + widget.destinationPos.longitude) / 2,
              ),
              zoom: 14,
            ),
            minMaxZoomPreference: MinMaxZoomPreference(12, 16),
            cameraTargetBounds: CameraTargetBounds(_areaLimit),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
          ),

          // Return button
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: ()=> Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.primary,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.arrow_back, color: theme.onPrimary,),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: VehicleSelector(
              vehicleTypes: _vehicleTypes,
              selectedVehicle: _selectedVehicle,
              onVehicleSelected: (vehicle) {
                setState(() => _selectedVehicle = vehicle);
              },
              theme: theme,
            ),
          )
        ],
      ),
    );
  }
}