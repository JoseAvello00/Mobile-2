import 'package:flutter/material.dart';

import '../../shared/rides/ride_estimate.dart';
import '../../shared/rides/ride_service.dart';
import '../confirm_ride/confirm_ride_factory.dart';

/// Navigation out of the home scene.
abstract interface class HomeCoordinator {
  void showConfirmRide(BuildContext context, RideDraft draft);
}

class DefaultHomeCoordinator implements HomeCoordinator {
  DefaultHomeCoordinator({required this.rideService});

  final RideService rideService;

  @override
  void showConfirmRide(BuildContext context, RideDraft draft) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            ConfirmRideFactory.make(draft: draft, rideService: rideService),
      ),
    );
  }
}
