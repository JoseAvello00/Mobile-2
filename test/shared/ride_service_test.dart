import 'package:fastmob/shared/rides/ride.dart';
import 'package:fastmob/shared/rides/ride_category.dart';
import 'package:fastmob/shared/rides/ride_result.dart';
import 'package:fastmob/shared/rides/ride_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes.dart';

Ride _ride(RideResult result) => (result as RideSuccess).ride;

void main() {
  late DefaultRideService service;

  setUp(() {
    service = DefaultRideService(delay: Duration.zero, assignAfterPolls: 3);
  });

  test('a request starts searching with the chosen quote', () async {
    final ride = _ride(
      await service.requestRide(
        draft: testDraft(category: RideCategory.eco),
        paymentMethod: PaymentMethod.card,
      ),
    );
    expect(ride.status, RideStatus.searching);
    expect(ride.category, RideCategory.eco);
    expect(ride.priceCents, 3600);
    expect(ride.paymentMethod, PaymentMethod.card);
    expect(ride.driver, isNull);
  });

  test('a driver is assigned after N polls', () async {
    final ride = _ride(
      await service.requestRide(
        draft: testDraft(category: RideCategory.eco),
        paymentMethod: PaymentMethod.pix,
      ),
    );

    expect(_ride(await service.fetchRide(ride.id)).status, RideStatus.searching);
    expect(_ride(await service.fetchRide(ride.id)).status, RideStatus.searching);

    final assigned = _ride(await service.fetchRide(ride.id));
    expect(assigned.status, RideStatus.driverAssigned);
    expect(assigned.driver!.vehicle, 'BYD Dolphin Mini branco');
    expect(assigned.etaSeconds, RideCategory.eco.etaSeconds);

    // Stays assigned.
    expect(
      _ride(await service.fetchRide(ride.id)).status,
      RideStatus.driverAssigned,
    );
  });

  test('cancelling stops the search', () async {
    final ride = _ride(
      await service.requestRide(
        draft: testDraft(),
        paymentMethod: PaymentMethod.pix,
      ),
    );
    final cancelled = _ride(await service.cancelRide(ride.id));
    expect(cancelled.status, RideStatus.cancelled);

    // A cancelled ride never gets a driver and cannot be cancelled again.
    for (var i = 0; i < 5; i++) {
      await service.fetchRide(ride.id);
    }
    expect(_ride(await service.fetchRide(ride.id)).driver, isNull);
    expect(await service.cancelRide(ride.id), isA<RideFailure>());
  });

  test('unknown ids fail without throwing', () async {
    expect(await service.fetchRide('nope'), isA<RideFailure>());
    expect(await service.cancelRide('nope'), isA<RideFailure>());
  });
}
