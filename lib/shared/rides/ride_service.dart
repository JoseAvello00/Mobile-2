import 'ride.dart';
import 'ride_category.dart';
import 'ride_estimate.dart';
import 'ride_result.dart';

/// Ride backend: `POST /rides`, `GET /rides/{id}`, `POST /rides/{id}/cancel`.
abstract interface class RideService {
  Future<RideResult> requestRide({
    required RideDraft draft,
    required PaymentMethod paymentMethod,
  });

  Future<RideResult> fetchRide(String id);

  Future<RideResult> cancelRide(String id);
}

/// In-memory [RideService] (mock). A driver accepts after [assignAfterPolls]
/// calls to [fetchRide].
///
/// Keep one instance for the whole flow: the factories pass it along.
class DefaultRideService implements RideService {
  DefaultRideService({
    this.delay = const Duration(milliseconds: 700),
    this.assignAfterPolls = 3,
  });

  final Duration delay;
  final int assignAfterPolls;

  final _rides = <String, Ride>{};
  final _polls = <String, int>{};
  int _nextId = 1;

  static const drivers = <RideCategory, Driver>{
    RideCategory.fast: Driver(
      id: 'drv_fast',
      name: 'Carlos Souza',
      rating: 4.9,
      vehicle: 'Onix prata',
      plate: 'QWE-1A23',
    ),
    RideCategory.comfort: Driver(
      id: 'drv_comfort',
      name: 'Mariana Lima',
      rating: 4.8,
      vehicle: 'Corolla preto',
      plate: 'RTY-4B56',
    ),
    RideCategory.moto: Driver(
      id: 'drv_moto',
      name: 'João Pereira',
      rating: 4.7,
      vehicle: 'Honda CG 160 vermelha',
      plate: 'MTO-7C89',
    ),
    RideCategory.eco: Driver(
      id: 'drv_eco',
      name: 'Fernanda Alves',
      rating: 5.0,
      vehicle: 'BYD Dolphin Mini branco',
      plate: 'ECO-0E01',
    ),
  };

  Future<void> _wait() =>
      delay == Duration.zero ? Future<void>.value() : Future<void>.delayed(delay);

  @override
  Future<RideResult> requestRide({
    required RideDraft draft,
    required PaymentMethod paymentMethod,
  }) async {
    await _wait();
    if (!draft.quote.available) {
      return const RideFailure('Categoria indisponível no momento.');
    }
    final ride = Ride(
      id: 'ride_${_nextId++}',
      status: RideStatus.searching,
      category: draft.quote.category,
      origin: draft.origin,
      destination: draft.destination,
      priceCents: draft.quote.priceCents,
      paymentMethod: paymentMethod,
      co2Grams: draft.quote.co2Grams,
    );
    _rides[ride.id] = ride;
    _polls[ride.id] = 0;
    return RideSuccess(ride);
  }

  @override
  Future<RideResult> fetchRide(String id) async {
    await _wait();
    final ride = _rides[id];
    if (ride == null) return const RideFailure('Corrida não encontrada.');
    if (ride.status != RideStatus.searching) return RideSuccess(ride);

    final polls = (_polls[id] ?? 0) + 1;
    _polls[id] = polls;
    if (polls < assignAfterPolls) return RideSuccess(ride);

    final assigned = ride.copyWith(
      status: RideStatus.driverAssigned,
      driver: drivers[ride.category],
      etaSeconds: ride.category.etaSeconds,
    );
    _rides[id] = assigned;
    return RideSuccess(assigned);
  }

  @override
  Future<RideResult> cancelRide(String id) async {
    await _wait();
    final ride = _rides[id];
    if (ride == null) return const RideFailure('Corrida não encontrada.');
    if (!ride.status.isCancellable) {
      return const RideFailure('Esta corrida não pode mais ser cancelada.');
    }
    final cancelled = ride.copyWith(status: RideStatus.cancelled);
    _rides[id] = cancelled;
    return RideSuccess(cancelled);
  }
}
