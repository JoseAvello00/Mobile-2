import 'package:flutter/material.dart';

import 'ride_category.dart';

/// Icons of the categories. Kept apart so the domain does not import Flutter.
extension RideCategoryUi on RideCategory {
  IconData get icon => switch (this) {
    RideCategory.fast => Icons.directions_car_outlined,
    RideCategory.comfort => Icons.directions_car_filled_outlined,
    RideCategory.moto => Icons.two_wheeler_outlined,
    RideCategory.eco => Icons.electric_car_outlined,
  };
}
