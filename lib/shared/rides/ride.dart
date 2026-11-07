import '../places/place.dart';
import 'ride_category.dart';

enum PaymentMethod {
  pix(apiValue: 'pix', label: 'Pix'),
  card(apiValue: 'card', label: 'Cartão'),
  cash(apiValue: 'cash', label: 'Dinheiro');

  const PaymentMethod({required this.apiValue, required this.label});

  final String apiValue;
  final String label;
}

/// Life cycle of a ride; [apiValue] matches `docs/api/rides.md`.
enum RideStatus {
  searching('searching'),
  driverAssigned('driver_assigned'),
  driverArriving('driver_arriving'),
  inProgress('in_progress'),
  completed('completed'),
  cancelled('cancelled'),
  noDriver('no_driver');

  const RideStatus(this.apiValue);

  final String apiValue;

  /// Statuses in which the passenger can still cancel.
  bool get isCancellable =>
      this == searching || this == driverAssigned || this == driverArriving;
}

class Driver {
  const Driver({
    required this.id,
    required this.name,
    required this.rating,
    required this.vehicle,
    required this.plate,
    this.photoUrl,
  });

  final String id;
  final String name;
  final double rating;

  /// Model and color ("BYD Dolphin Mini branco").
  final String vehicle;
  final String plate;
  final String? photoUrl;
}

class Ride {
  const Ride({
    required this.id,
    required this.status,
    required this.category,
    required this.origin,
    required this.destination,
    required this.priceCents,
    required this.paymentMethod,
    this.co2Grams = 0,
    this.driver,
    this.etaSeconds,
  });

  final String id;
  final RideStatus status;
  final RideCategory category;
  final Place origin;
  final Place destination;
  final int priceCents;
  final PaymentMethod paymentMethod;
  final int co2Grams;
  final Driver? driver;

  /// Time until the driver arrives, once there is one.
  final int? etaSeconds;

  Ride copyWith({RideStatus? status, Driver? driver, int? etaSeconds}) {
    return Ride(
      id: id,
      status: status ?? this.status,
      category: category,
      origin: origin,
      destination: destination,
      priceCents: priceCents,
      paymentMethod: paymentMethod,
      co2Grams: co2Grams,
      driver: driver ?? this.driver,
      etaSeconds: etaSeconds ?? this.etaSeconds,
    );
  }
}
