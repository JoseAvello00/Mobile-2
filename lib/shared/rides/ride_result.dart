import 'ride.dart';

/// Outcome of a [RideService] call. The service never throws.
sealed class RideResult {
  const RideResult();
}

final class RideSuccess extends RideResult {
  const RideSuccess(this.ride);

  final Ride ride;
}

final class RideFailure extends RideResult {
  const RideFailure(this.message);

  final String message;
}
