import 'package:fastmob/shared/places/palmas_places.dart';
import 'package:fastmob/shared/places/place.dart';
import 'package:fastmob/shared/rides/ride_category.dart';
import 'package:fastmob/shared/rides/ride_estimate.dart';
import 'package:fastmob/shared/rides/ride_estimator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  const estimator = DefaultRideEstimator();

  test('haversine: one degree of latitude is about 111 km', () {
    final meters = DefaultRideEstimator.haversineMeters(
      const LatLng(0, 0),
      const LatLng(1, 0),
    );
    expect(meters, closeTo(111195, 50));
  });

  test('distance is the straight line times 1.3', () async {
    final estimate = await estimator.estimate(
      origin: PalmasPlaces.myLocation,
      destination: PalmasPlaces.airport,
    );
    final straight = DefaultRideEstimator.haversineMeters(
      PalmasPlaces.myLocation.location,
      PalmasPlaces.airport.location,
    );
    expect(estimate.distanceMeters, (straight * 1.3).round());
    expect(estimate.durationSeconds, (estimate.distanceMeters / 9).round());
  });

  test('quotes every category, prices rounded to 10 cents', () async {
    final estimate = await estimator.estimate(
      origin: PalmasPlaces.myLocation,
      destination: PalmasPlaces.airport,
    );
    expect(
      estimate.quotes.map((q) => q.category),
      RideCategory.values,
    );
    for (final quote in estimate.quotes) {
      expect(quote.priceCents % 10, 0);
      expect(quote.priceCents, greaterThan(quote.category.fare.minimumCents));
    }
  });

  test('price formula', () {
    // 400 + 10 km * 160 + 20 min * 20 = 2400.
    expect(
      DefaultRideEstimator.price(RideCategory.fast.fare, 10000, 1200),
      2400,
    );
  });

  test('short trips pay the minimum fare', () async {
    const nearby = Place(
      id: 'nearby',
      name: 'Vizinho',
      address: '',
      location: LatLng(-10.1894, -48.3296),
    );
    final estimate = await estimator.estimate(
      origin: PalmasPlaces.myLocation,
      destination: nearby,
    );
    for (final quote in estimate.quotes) {
      expect(quote.priceCents, quote.category.fare.minimumCents);
    }
  });

  test('eco emits zero and avoids what a Fast would emit', () async {
    final estimate = await estimator.estimate(
      origin: PalmasPlaces.myLocation,
      destination: PalmasPlaces.airport,
    );
    final eco = estimate.quoteFor(RideCategory.eco)!;
    final fast = estimate.quoteFor(RideCategory.fast)!;
    expect(eco.co2Grams, 0);
    expect(fast.co2Grams, greaterThan(0));

    final ecoDraft = RideDraft(
      origin: PalmasPlaces.myLocation,
      destination: PalmasPlaces.airport,
      estimate: estimate,
      quote: eco,
    );
    expect(ecoDraft.co2AvoidedGrams, fast.co2Grams);

    final fastDraft = RideDraft(
      origin: PalmasPlaces.myLocation,
      destination: PalmasPlaces.airport,
      estimate: estimate,
      quote: fast,
    );
    expect(fastDraft.co2AvoidedGrams, 0);
  });
}
