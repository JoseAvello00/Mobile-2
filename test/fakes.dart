import 'package:fastmob/scenes/home/home_coordinator.dart';
import 'package:fastmob/shared/places/palmas_places.dart';
import 'package:fastmob/shared/rides/ride.dart';
import 'package:fastmob/shared/rides/ride_category.dart';
import 'package:fastmob/shared/rides/ride_estimate.dart';
import 'package:fastmob/shared/rides/ride_result.dart';
import 'package:fastmob/shared/rides/ride_service.dart';
import 'package:fastmob_design_system/fastmob_design_system.dart';
import 'package:flutter/material.dart';

Widget app(Widget home) => MaterialApp(theme: AppTheme.light(), home: home);

const testEstimate = RideEstimate(
  distanceMeters: 14200,
  durationSeconds: 1580,
  quotes: [
    RideQuote(
      category: RideCategory.fast,
      priceCents: 3270,
      etaSeconds: 240,
      co2Grams: 2130,
    ),
    RideQuote(
      category: RideCategory.eco,
      priceCents: 3600,
      etaSeconds: 300,
      co2Grams: 0,
    ),
  ],
);

RideDraft testDraft({RideCategory category = RideCategory.fast}) => RideDraft(
  origin: PalmasPlaces.myLocation,
  destination: PalmasPlaces.airport,
  estimate: testEstimate,
  quote: testEstimate.quoteFor(category)!,
);

Ride testRide({RideStatus status = RideStatus.searching, Driver? driver}) =>
    Ride(
      id: 'ride_1',
      status: status,
      category: RideCategory.eco,
      origin: PalmasPlaces.myLocation,
      destination: PalmasPlaces.airport,
      priceCents: 3600,
      paymentMethod: PaymentMethod.pix,
      driver: driver,
      etaSeconds: driver == null ? null : 300,
    );

/// [RideService] with scripted answers and no delays or timers.
class FakeRideService implements RideService {
  RideResult? requestResult;
  RideResult? cancelResult;

  /// Answers of [fetchRide], in order; the last one repeats.
  List<RideResult> fetchResults = [];

  int requestCalls = 0;
  int fetchCalls = 0;
  int cancelCalls = 0;
  PaymentMethod? lastPaymentMethod;

  @override
  Future<RideResult> requestRide({
    required RideDraft draft,
    required PaymentMethod paymentMethod,
  }) async {
    requestCalls++;
    lastPaymentMethod = paymentMethod;
    return requestResult ?? RideSuccess(testRide());
  }

  @override
  Future<RideResult> fetchRide(String id) async {
    final index = fetchCalls < fetchResults.length
        ? fetchCalls
        : fetchResults.length - 1;
    fetchCalls++;
    return index < 0 ? RideSuccess(testRide()) : fetchResults[index];
  }

  @override
  Future<RideResult> cancelRide(String id) async {
    cancelCalls++;
    return cancelResult ??
        RideSuccess(testRide(status: RideStatus.cancelled));
  }
}

class FakeHomeCoordinator implements HomeCoordinator {
  RideDraft? shown;

  @override
  void showConfirmRide(BuildContext context, RideDraft draft) => shown = draft;
}
