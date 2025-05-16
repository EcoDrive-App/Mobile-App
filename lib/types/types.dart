import 'package:flutter/widgets.dart';

class VehicleType {
  final String name;
  final IconData icon;
  final int quantity;
  final int maxCapacity;

  VehicleType(this.name, this.icon, this.maxCapacity, this.quantity);
}