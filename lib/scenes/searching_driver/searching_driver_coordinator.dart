import 'package:flutter/material.dart';

import '../../shared/rides/ride_service.dart';
import '../home/home_factory.dart';

/// Navigation out of the search for a driver.
abstract interface class SearchingDriverCoordinator {
  /// Back to a fresh Home, clearing the ride flow from the stack.
  void showHome(BuildContext context);
}

class DefaultSearchingDriverCoordinator implements SearchingDriverCoordinator {
  DefaultSearchingDriverCoordinator({required this.rideService});

  final RideService rideService;

  @override
  void showHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => HomeFactory.make(rideService: rideService),
      ),
      (_) => false,
    );
  }
}
