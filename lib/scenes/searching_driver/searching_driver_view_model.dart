import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../shared/rides/ride.dart';
import '../../shared/rides/ride_result.dart';
import '../../shared/rides/ride_service.dart';
import '../../shared/safe_notifier.dart';
import 'searching_driver_coordinator.dart';

/// Polls the ride until a driver accepts, and lets the passenger cancel.
class SearchingDriverViewModel extends ChangeNotifier with SafeNotifier {
  SearchingDriverViewModel({
    required Ride ride,
    required this._rideService,
    required this._coordinator,
    this.pollInterval = const Duration(seconds: 2),
  }) : _ride = ride;

  final RideService _rideService;
  final SearchingDriverCoordinator _coordinator;

  /// Time between two `GET /rides/{id}`. Tests pass a short one.
  final Duration pollInterval;

  Ride _ride;
  Timer? _timer;
  bool _isPolling = false;
  bool _isCancelling = false;
  String? _errorMessage;

  Ride get ride => _ride;
  RideStatus get status => _ride.status;
  Driver? get driver => _ride.driver;
  bool get isSearching => _ride.status == RideStatus.searching;
  bool get hasDriver => _ride.driver != null;
  bool get isCancelling => _isCancelling;
  String? get errorMessage => _errorMessage;

  bool get canCancel => _ride.status.isCancellable && !_isCancelling;

  /// Starts polling. The View calls it once, in `initState`.
  void start() {
    if (_timer != null || !isSearching) return;
    _timer = Timer.periodic(pollInterval, (_) => poll());
  }

  /// One poll. Public so tests can drive it without timers.
  Future<void> poll() async {
    if (_isPolling || isDisposed) return;
    _isPolling = true;
    final result = await _rideService.fetchRide(_ride.id);
    _isPolling = false;
    if (isDisposed) return;

    switch (result) {
      case RideSuccess(:final ride):
        _ride = ride;
        _errorMessage = null;
      case RideFailure(:final message):
        _errorMessage = message;
    }
    if (!isSearching) _stop();
    notifyListeners();
  }

  /// Cancels the ride. Returns true when the passenger can leave the screen.
  Future<bool> cancel() async {
    if (!canCancel) return false;
    _isCancelling = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _rideService.cancelRide(_ride.id);
    _isCancelling = false;
    switch (result) {
      case RideSuccess(:final ride):
        _ride = ride;
        _stop();
      case RideFailure(:final message):
        _errorMessage = message;
    }
    notifyListeners();
    return result is RideSuccess;
  }

  void openHome(BuildContext context) => _coordinator.showHome(context);

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }
}
