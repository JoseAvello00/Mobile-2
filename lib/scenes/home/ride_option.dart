import 'package:flutter/material.dart';

class RideOption {
  const RideOption({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.arrival,
    required this.icon,
  });

  final String id;
  final String name;
  final String description;
  final String price;
  final String arrival;
  final IconData icon;
}
