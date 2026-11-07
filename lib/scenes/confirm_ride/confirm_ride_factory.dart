import 'package:flutter/widgets.dart';

import '../../shared/rides/ride_estimate.dart';
import '../../shared/rides/ride_service.dart';
import 'confirm_ride_coordinator.dart';
import 'confirm_ride_view.dart';
import 'confirm_ride_view_model.dart';

/// Assembles the confirmation scene for the [draft] chosen on the Home.
abstract final class ConfirmRideFactory {
  static Widget make({
    required RideDraft draft,
    required RideService rideService,
  }) {
    final viewModel = ConfirmRideViewModel(
      draft: draft,
      rideService: rideService,
      coordinator: DefaultConfirmRideCoordinator(rideService: rideService),
    );
    return ConfirmRideView(viewModel: viewModel);
  }
}
