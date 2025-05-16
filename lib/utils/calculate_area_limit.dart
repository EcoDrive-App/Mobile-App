import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

LatLngBounds calculateAreaLimit(LatLng center, double radiusInKm) {
  const double earthRadius = 6371.0;
  double latDelta = (radiusInKm / earthRadius) * (180 / pi);
  double lngDelta = (radiusInKm / (earthRadius * cos(pi * center.latitude / 180))) * (180 / pi);

  return LatLngBounds(
    southwest: LatLng(center.latitude - latDelta, center.longitude - lngDelta),
    northeast: LatLng(center.latitude + latDelta, center.longitude + lngDelta),
  );
}