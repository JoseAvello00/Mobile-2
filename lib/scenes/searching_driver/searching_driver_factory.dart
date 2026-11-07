import 'package:flutter/widgets.dart';

import '../../shared/rides/ride.dart';
import '../../shared/rides/ride_service.dart';
import 'searching_driver_coordinator.dart';
import 'searching_driver_view.dart';
import 'searching_driver_view_model.dart';

abstract final class SearchingDriverFactory {
  static Widget make({required Ride ride, required RideService rideService}) {
    final viewModel = SearchingDriverViewModel(
      ride: ride,
      rideService: rideService,
      coordinator: DefaultSearchingDriverCoordinator(rideService: rideService),
    );
    return SearchingDriverView(viewModel: viewModel);
  }
}
