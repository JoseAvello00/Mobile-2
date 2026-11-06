import '../places/place.dart';
import 'ride_category.dart';

/// Price and wait of one category for a trip.
class RideQuote {
  const RideQuote({
    required this.category,
    required this.priceCents,
    required this.etaSeconds,
    required this.co2Grams,
    this.available = true,
  });

  final RideCategory category;
  final int priceCents;

  /// Time until the driver arrives.
  final int etaSeconds;

  /// Tailpipe emission of the whole trip.
  final int co2Grams;
  final bool available;
}

/// Answer of the estimate: the trip and one quote per category.
class RideEstimate {
  const RideEstimate({
    required this.distanceMeters,
    required this.durationSeconds,
    required this.quotes,
  });

  final int distanceMeters;
  final int durationSeconds;
  final List<RideQuote> quotes;

  RideQuote? quoteFor(RideCategory category) {
    for (final quote in quotes) {
      if (quote.category == category) return quote;
    }
    return null;
  }
}

/// What the passenger chose on the Home, handed to the confirmation.
class RideDraft {
  const RideDraft({
    required this.origin,
    required this.destination,
    required this.estimate,
    required this.quote,
  });

  final Place origin;
  final Place destination;
  final RideEstimate estimate;
  final RideQuote quote;

  /// Emission that riding electric avoids, compared with a Fast car.
  /// Zero for the other categories, whose emission is offset instead.
  int get co2AvoidedGrams {
    if (!quote.category.isElectric) return 0;
    final km = estimate.distanceMeters / 1000;
    return (RideCategory.fast.co2GramsPerKm * km).round();
  }
}
