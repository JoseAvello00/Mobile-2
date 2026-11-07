import 'package:flutter/widgets.dart';

import '../home/home_factory.dart';

/// Navigation out of the login scene.
abstract interface class LoginCoordinator {
  void showHome(BuildContext context);
}

class DefaultLoginCoordinator implements LoginCoordinator {
  @override
  void showHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (_, _, _) => HomeFactory.make(),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }
}
