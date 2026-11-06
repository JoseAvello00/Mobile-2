import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../shared/places/palmas_places.dart';
import '../../shared/places/place.dart';
import '../../shared/places/place_search.dart';
import '../../shared/rides/ride_category.dart';
import '../../shared/rides/ride_estimate.dart';
import '../../shared/rides/ride_estimator.dart';
import '../../shared/safe_notifier.dart';
import 'home_coordinator.dart';

/// State and actions of the home scene: pick a destination in Palmas, then a
/// ride category.
class HomeViewModel extends ChangeNotifier with SafeNotifier {
  HomeViewModel({
    required this._placeSearch,
    required this._estimator,
    required this._coordinator,
    this.origin = PalmasPlaces.myLocation,
  }) {
    onQueryChanged('');
  }

  final PlaceSearch _placeSearch;
  final RideEstimator _estimator;
  final HomeCoordinator _coordinator;

  /// Pickup point. Fixed until geolocation arrives.
  final Place origin;

  String _query = '';
  List<Place> _results = const [];
  Place? _destination;
  RideEstimate? _estimate;
  RideQuote? _selectedQuote;
  bool _isEstimating = false;

  // Answers that arrive after a newer request are dropped.
  int _searchToken = 0;
  int _estimateToken = 0;

  String get query => _query;
  List<Place> get results => _results;
  Place? get destination => _destination;
  RideEstimate? get estimate => _estimate;
  RideQuote? get selectedQuote => _selectedQuote;
  bool get isEstimating => _isEstimating;

  List<RideQuote> get quotes => _estimate?.quotes ?? const [];

  /// Everything the confirmation needs, or null while incomplete.
  RideDraft? get draft {
    final destination = _destination;
    final estimate = _estimate;
    final quote = _selectedQuote;
    if (destination == null || estimate == null || quote == null) return null;
    return RideDraft(
      origin: origin,
      destination: destination,
      estimate: estimate,
      quote: quote,
    );
  }

  bool get canContinue => draft != null && !_isEstimating;

  Future<void> onQueryChanged(String value) async {
    _query = value;
    final token = ++_searchToken;
    final results = await _placeSearch.search(value);
    if (token != _searchToken) return;
    _results = results;
    notifyListeners();
  }

  Future<void> selectDestination(Place place) async {
    _destination = place;
    _estimate = null;
    _selectedQuote = null;
    _isEstimating = true;
    final token = ++_estimateToken;
    notifyListeners();

    final estimate = await _estimator.estimate(
      origin: origin,
      destination: place,
    );
    if (token != _estimateToken) return;
    _estimate = estimate;
    _selectedQuote =
        estimate.quoteFor(RideCategory.fast) ??
        (estimate.quotes.isEmpty ? null : estimate.quotes.first);
    _isEstimating = false;
    notifyListeners();
  }

  void clearDestination() {
    _estimateToken++;
    _destination = null;
    _estimate = null;
    _selectedQuote = null;
    _isEstimating = false;
    // The search field comes back empty, so the suggestions do too.
    _query = '';
    notifyListeners();
    onQueryChanged('');
  }

  void selectQuote(RideQuote quote) {
    if (!quote.available) return;
    _selectedQuote = quote;
    notifyListeners();
  }

  void continueToConfirm(BuildContext context) {
    final draft = this.draft;
    if (draft == null || _isEstimating) return;
    _coordinator.showConfirmRide(context, draft);
  }
}
