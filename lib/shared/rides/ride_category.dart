/// Fare of a ride category, in cents.
class RideFare {
  const RideFare({
    required this.baseCents,
    required this.perKmCents,
    required this.perMinuteCents,
    required this.minimumCents,
  });

  final int baseCents;
  final int perKmCents;
  final int perMinuteCents;
  final int minimumCents;
}

/// Ride categories offered by FastMob.
///
/// [co2GramsPerKm] are illustrative figures for the project (see
/// `docs/design/tema.md`), not measurements.
enum RideCategory {
  fast(
    apiValue: 'fast',
    label: 'Fast',
    description: 'Mais barato',
    co2GramsPerKm: 150,
    etaSeconds: 240,
    fare: RideFare(
      baseCents: 400,
      perKmCents: 160,
      perMinuteCents: 20,
      minimumCents: 800,
    ),
  ),
  comfort(
    apiValue: 'comfort',
    label: 'Conforto',
    description: 'Carros novos',
    co2GramsPerKm: 180,
    etaSeconds: 360,
    fare: RideFare(
      baseCents: 540,
      perKmCents: 216,
      perMinuteCents: 27,
      minimumCents: 1080,
    ),
  ),
  moto(
    apiValue: 'moto',
    label: 'Moto',
    description: 'Mais ágil',
    co2GramsPerKm: 80,
    etaSeconds: 180,
    fare: RideFare(
      baseCents: 280,
      perKmCents: 112,
      perMinuteCents: 14,
      minimumCents: 560,
    ),
  ),
  eco(
    apiValue: 'eco',
    label: 'Eco',
    description: '100% elétrico',
    co2GramsPerKm: 0,
    etaSeconds: 300,
    fare: RideFare(
      baseCents: 440,
      perKmCents: 176,
      perMinuteCents: 22,
      minimumCents: 880,
    ),
  );

  const RideCategory({
    required this.apiValue,
    required this.label,
    required this.description,
    required this.co2GramsPerKm,
    required this.etaSeconds,
    required this.fare,
  });

  /// Value of `category` in the API.
  final String apiValue;
  final String label;
  final String description;

  /// Tailpipe emission per km. Zero for the electric category.
  final int co2GramsPerKm;

  /// Typical wait for a driver.
  final int etaSeconds;
  final RideFare fare;

  bool get isElectric => this == RideCategory.eco;
}
