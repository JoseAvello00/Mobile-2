import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../shared/rides/ride.dart';
import '../../shared/rides/ride_estimate.dart';
import '../../shared/rides/ride_result.dart';
import '../../shared/rides/ride_service.dart';
import '../../shared/safe_notifier.dart';
import 'confirm_ride_coordinator.dart';

/// State and actions of the confirmation: payment method and the request.
class ConfirmRideViewModel extends ChangeNotifier with SafeNotifier {
  ConfirmRideViewModel({
    required this.draft,
    required this._rideService,
    required this._coordinator,
  });

  final RideDraft draft;
  final RideService _rideService;
  final ConfirmRideCoordinator _coordinator;

  PaymentMethod _paymentMethod = PaymentMethod.pix;
  bool _isSubmitting = false;
  String? _errorMessage;
  Ride? _ride;

  PaymentMethod get paymentMethod => _paymentMethod;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  /// The requested ride, once the request succeeds.
  Ride? get ride => _ride;

  bool get isElectric => draft.quote.category.isElectric;

  void selectPaymentMethod(PaymentMethod method) {
    _paymentMethod = method;
    notifyListeners();
  }

  /// Requests the ride. Returns true on success, like the login.
  Future<bool> submit() async {
    if (_isSubmitting) return false;
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _rideService.requestRide(
      draft: draft,
      paymentMethod: _paymentMethod,
    );

    _isSubmitting = false;
    switch (result) {
      case RideSuccess(:final ride):
        _ride = ride;
      case RideFailure(:final message):
        _errorMessage = message;
    }
    notifyListeners();
    return result is RideSuccess;
  }

  void openSearching(BuildContext context) {
    final ride = _ride;
    if (ride != null) _coordinator.showSearchingDriver(context, ride);
  }
}
