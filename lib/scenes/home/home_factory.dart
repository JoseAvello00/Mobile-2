import 'package:flutter/widgets.dart';

import '../../shared/places/place_search.dart';
import '../../shared/rides/ride_estimator.dart';
import '../../shared/rides/ride_service.dart';
import 'home_coordinator.dart';
import 'home_view.dart';
import 'home_view_model.dart';

/// Assembles the home scene.
///
/// [rideService] is shared by the whole ride flow (Home -> Confirm ->
/// Searching); pass the same instance when coming back to the Home.
abstract final class HomeFactory {
  static Widget make({RideService? rideService}) {
    final viewModel = HomeViewModel(
      placeSearch: const DefaultPlaceSearch(),
      estimator: const DefaultRideEstimator(),
      coordinator: DefaultHomeCoordinator(
        rideService: rideService ?? DefaultRideService(),
      ),
    );
    return HomeView(viewModel: viewModel);
  }
}
