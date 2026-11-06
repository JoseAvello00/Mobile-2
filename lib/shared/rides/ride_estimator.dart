import 'dart:math' as math;

import 'package:latlong2/latlong.dart';

import '../places/place.dart';
import 'ride_category.dart';
import 'ride_estimate.dart';

/// Computes price and time of a trip for every category.
abstract interface class RideEstimator {
  Future<RideEstimate> estimate({
    required Place origin,
    required Place destination,
  });
}

/// Offline [RideEstimator]: straight-line distance stretched to street length.
///
/// The API (`POST /rides/estimates`) will replace it; the formula is
/// documented in `docs/design/tema.md`.
class DefaultRideEstimator implements RideEstimator {
  const DefaultRideEstimator({
    this.streetFactor = 1.3,
    this.averageSpeedMetersPerSecond = 9,
  });

  /// Streets are longer than the straight line between two points.
  final double streetFactor;

  /// About 32 km/h, city traffic.
  final double averageSpeedMetersPerSecond;

  @override
  Future<RideEstimate> estimate({
    required Place origin,
    required Place destination,
  }) async {
    final meters =
        (haversineMeters(origin.location, destination.location) *
                streetFactor)
            .round();
    final seconds = (meters / averageSpeedMetersPerSecond).round();
    return RideEstimate(
      distanceMeters: meters,
      durationSeconds: seconds,
      quotes: [
        for (final category in RideCategory.values)
          RideQuote(
            category: category,
            priceCents: price(category.fare, meters, seconds),
            etaSeconds: category.etaSeconds,
            co2Grams: (category.co2GramsPerKm * meters / 1000).round(),
          ),
      ],
    );
  }

  /// `max(minimum, base + km * perKm + min * perMinute)`, rounded to 10 cents.
  static int price(RideFare fare, int meters, int seconds) {
    final raw =
        fare.baseCents +
        meters / 1000 * fare.perKmCents +
        seconds / 60 * fare.perMinuteCents;
    final rounded = (raw / 10).round() * 10;
    return math.max(fare.minimumCents, rounded);
  }

  /// Great-circle distance between two points, in meters.
  static double haversineMeters(LatLng a, LatLng b) {
    const earthRadius = 6371000.0;
    double rad(double degrees) => degrees * math.pi / 180;
    final dLat = rad(b.latitude - a.latitude);
    final dLng = rad(b.longitude - a.longitude);
    final h =
        math.pow(math.sin(dLat / 2), 2) +
        math.cos(rad(a.latitude)) *
            math.cos(rad(b.latitude)) *
            math.pow(math.sin(dLng / 2), 2);
    return 2 * earthRadius * math.asin(math.sqrt(h));
  }
}
