import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with ChangeNotifier {
  static const String _lastLatitudeKey = 'last_latitude';
  static const String _lastLongitudeKey = 'last_longitude';
  static const String _lastPositionTimestampKey = 'last_position_timestamp';
  static const int _positionExpirationHours = 24;

  Position? _lastKnownPosition;
  bool _isLoading = true;

  Position? get lastKnownPosition => _lastKnownPosition;
  bool get isLoading => _isLoading;

  Future<void> savePosition(Position position) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_lastLatitudeKey, position.latitude);
      await prefs.setDouble(_lastLongitudeKey, position.longitude);
      await prefs.setString(
        _lastPositionTimestampKey,
        position.timestamp.toIso8601String()
      );

      _lastKnownPosition = position;
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving position: $e');
    }
  }

  Future<Position?> loadLastKnownPosition() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final latitude = prefs.getDouble(_lastLatitudeKey);
      final longitude = prefs.getDouble(_lastLongitudeKey);
      final timestampStr = prefs.getString(_lastPositionTimestampKey);

      if (latitude == null || longitude == null || timestampStr == null) {
        return null;
      }

      // Check if the saved position is not too old
      final timestamp = DateTime.parse(timestampStr);
      if (DateTime.now().difference(timestamp).inHours > _positionExpirationHours) {
        return null;
      }

      final position = Position(
        latitude: latitude,
        longitude: longitude,
        timestamp: timestamp,
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
        floor: 0,
        isMocked: false,
      );

      _lastKnownPosition = position;
      notifyListeners();
      return position;
    } catch (e) {
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearSavedPosition() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastLatitudeKey);
    await prefs.remove(_lastLongitudeKey);
    await prefs.remove(_lastPositionTimestampKey);

    _lastKnownPosition = null;
    notifyListeners();
  }

  Position getDefaultPosition() {
    return Position(
      latitude: 6.2442,
      longitude: -75.5812,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
      floor: 0,
      isMocked: false,
    );
  }
}