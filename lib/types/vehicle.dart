import 'package:flutter/widgets.dart';

class Vehicle {
  final String name;
  final IconData icon;
  final int quantity;
  final int maxCapacity;

  Vehicle(this.name, this.icon, this.maxCapacity, this.quantity);
}