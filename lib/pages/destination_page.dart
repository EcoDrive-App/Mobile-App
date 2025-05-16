import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/components/custom_snack_bar.dart';

class DestinationPage extends StatefulWidget {
  final String? initialAddress;
  final LatLng? initialPos;

  const DestinationPage({super.key, required this.initialAddress, required this.initialPos});

  @override
  State<DestinationPage> createState() => _DestinationPageState();
}

class _DestinationPageState extends State<DestinationPage> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final FocusNode _fromFocusNode = FocusNode();
  final FocusNode _toFocusNode = FocusNode();

  final _places = GoogleMapsPlaces(apiKey: dotenv.get('GOOGLE_MAPS_API_KEY'));
  List<Prediction> _fromPredictions = [];
  List<Prediction> _toPredictions = [];
  bool _showFromPredictions = false;
  bool _showToPredictions = false;

  bool _isSelectingPrediction = false;

  Timer? _fromDebounceTimer;
  Timer? _toDebounceTimer;

  LatLng? _fromLatLng;
  LatLng? _toLatLng;

  List<String> savedAddresses = [
    'ITM Fraternidad',
    'ITM Robledo',
    'Castilla',
    'Centro Comercial Unicentro',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialAddress != null) {
      _fromController.text = widget.initialAddress!;
    }

    if (widget.initialPos != null) {
      setState(() {
        _fromLatLng = LatLng(widget.initialPos!.latitude, widget.initialPos!.longitude);
      });
    }

    _fromController.addListener(() => _onFromTextChanged());
    _toController.addListener(() => _onToTextChanged());
  }

  void _onFromTextChanged() async {
    if (!_fromFocusNode.hasFocus || _isSelectingPrediction) return;

    _fromDebounceTimer?.cancel();

    _fromDebounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final query = _fromController.text;

      if (query.isEmpty) {
        setState(() {
          _fromPredictions.clear();
          _toPredictions.clear();
          _showFromPredictions = false;
          _showToPredictions = false;
        });
        return;
      }

      final predictions = await _getPlacePredictions(query);
      setState(() {
        _fromPredictions = predictions;
        _showFromPredictions = predictions.isNotEmpty;
        _showToPredictions = false;
      });
    });
  }

  void _onToTextChanged() async {
    if (!_toFocusNode.hasFocus || _isSelectingPrediction) return;

    _toDebounceTimer?.cancel();

    _toDebounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final query = _toController.text;

      if (query.isEmpty) {
        setState(() {
          _fromPredictions.clear();
          _toPredictions.clear();
          _showFromPredictions = false;
          _showToPredictions = false;
        });
        return;
      }

      final predictions = await _getPlacePredictions(query);
      setState(() {
        _toPredictions = predictions;
        _showToPredictions = predictions.isNotEmpty;
        _showFromPredictions = false;
      });
    });
  }

  Future<List<Prediction>> _getPlacePredictions(String query) async {
    if (query.isEmpty) return [];

    try {
      final response = await _places.autocomplete(
        query,
        language: 'es',
        components: [Component('country', 'co')],
        // limit the predictions to Medellin
        location: Location(lat: 6.2442, lng: -75.5812),
        radius: 20000,
      );
      return response.predictions;
    } catch (e) {
      debugPrint('Error getting predictions: $e');
      return [];
    }
  }

  void _sent(){
    if (_fromLatLng == null || _toLatLng == null) {
      CustomSnackBar.show(context: context, text: 'Por favor selecciona ambas direcciones', icon: Icons.warning);
      return;
    }

    Navigator.pushNamed(
      context,
      '/navigation',
      arguments: {
        'currentAddress': _fromController.text,
        'currentPos': _fromLatLng,
        'destinationAddress': _toController.text,
        'destinationPos': _toLatLng,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar destino'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _fromController,
              focusNode: _fromFocusNode,
              decoration: InputDecoration(
                hintText: '¿Desde dónde sales?',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.my_location),
              ),
              onChanged: (value) => _onFromTextChanged(),
            ),

            const SizedBox(height: 20),
            TextField(
              controller: _toController,
              focusNode: _toFocusNode,
              decoration: InputDecoration(
                hintText: '¿Hacia dónde vas?',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.place),
              ),
              onChanged: (value) => _onToTextChanged(),
            ),

            const SizedBox(height: 20),
            GestureDetector(
              onTap: _sent,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: theme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text("Empezar", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600,),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Text(
              _showFromPredictions || _showToPredictions
                  ? "Resultados de búsqueda"
                  : "Direcciones guardadas",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),


            Expanded(
              child: _buildAddressList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressList() {
    if (_showFromPredictions) {
      return ListView.builder(
        itemCount: _fromPredictions.length,
        itemBuilder: (context, index) {
          final prediction = _fromPredictions[index];
          return ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: Text(prediction.description ?? ''),
            onTap: () async {
              _fromFocusNode.unfocus();
              setState(() {
                _isSelectingPrediction = true;
                _fromController.text = prediction.description ?? '';
                _fromPredictions.clear();
                _toPredictions.clear();
                _showFromPredictions = false;
                _showToPredictions = false;
              });
              final details = await _places.getDetailsByPlaceId(prediction.placeId ?? '');
              final location = details.result.geometry?.location;
              if (location != null) {
                _fromLatLng = LatLng(location.lat, location.lng);
              }

              Future.delayed(Duration(milliseconds: 300), () {
                _isSelectingPrediction = false;
              });
            },
          );
        },
      );
    } else if (_showToPredictions) {
      return ListView.builder(
        itemCount: _toPredictions.length,
        itemBuilder: (context, index) {
          final prediction = _toPredictions[index];
          return ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: Text(prediction.description ?? ''),
            onTap: () async {
              _toFocusNode.unfocus();
              setState(() {
                _isSelectingPrediction = true;
                _toController.text = prediction.description ?? '';
                _fromPredictions.clear();
                _toPredictions.clear();
                _showFromPredictions = false;
                _showToPredictions = false;
              });
              final details = await _places.getDetailsByPlaceId(prediction.placeId ?? '');
              final location = details.result.geometry?.location;
              if (location != null) {
                _toLatLng = LatLng(location.lat, location.lng);
              }

              Future.delayed(Duration(milliseconds: 300), () {
                _isSelectingPrediction = false;
              });
            },
          );
        },
      );
    } else {
      return ListView.builder(
        itemCount: savedAddresses.length,
        itemBuilder: (context, index) {
          final address = savedAddresses[index];
          return ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: Text(address),
            onTap: () {
              setState(() {
                _toController.text = address;
              });
            },
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _fromDebounceTimer?.cancel();
    _toDebounceTimer?.cancel();
    _fromController.dispose();
    _toController.dispose();
    _fromFocusNode.dispose();
    _toFocusNode.dispose();
    _places.dispose();
    super.dispose();
  }
}