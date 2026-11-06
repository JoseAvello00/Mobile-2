import 'package:flutter/foundation.dart';

/// Ignores [notifyListeners] after [dispose], so an answer that arrives after
/// the user left the screen does not throw.
mixin SafeNotifier on ChangeNotifier {
  bool _disposed = false;

  bool get isDisposed => _disposed;

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
