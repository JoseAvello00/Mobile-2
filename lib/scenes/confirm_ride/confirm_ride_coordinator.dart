import 'package:flutter/material.dart';

import '../../shared/rides/ride.dart';
import '../../shared/rides/ride_service.dart';
import '../searching_driver/searching_driver_factory.dart';

/// Navigation out of the confirmation scene.
abstract interface class ConfirmRideCoordinator {
  void showSearchingDriver(BuildContext context, Ride ride);
}

class DefaultConfirmRideCoordinator implements ConfirmRideCoordinator {
  DefaultConfirmRideCoordinator({required this.rideService});

  final RideService rideService;

  /// Replaces the confirmation: "back" from the search must not reopen it.
  @override
  void showSearchingDriver(BuildContext context, Ride ride) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) =>
            SearchingDriverFactory.make(ride: ride, rideService: rideService),
      ),
    );
  }
}
