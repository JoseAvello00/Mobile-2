import 'package:fastmob/scenes/searching_driver/searching_driver_coordinator.dart';
import 'package:fastmob/scenes/searching_driver/searching_driver_view.dart';
import 'package:fastmob/scenes/searching_driver/searching_driver_view_model.dart';
import 'package:fastmob/shared/map/city_map.dart';
import 'package:fastmob/shared/rides/ride.dart';
import 'package:fastmob/shared/rides/ride_result.dart';
import 'package:fastmob/shared/rides/ride_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes.dart';

class _FakeCoordinator implements SearchingDriverCoordinator {
  int homes = 0;

  @override
  void showHome(BuildContext context) => homes++;
}

const _driver = Driver(
  id: 'd1',
  name: 'Fernanda Alves',
  rating: 5,
  vehicle: 'BYD Dolphin Mini branco',
  plate: 'ECO-0E01',
);

SearchingDriverViewModel _viewModel(
  RideService service, {
  SearchingDriverCoordinator? coordinator,
  Duration pollInterval = const Duration(seconds: 2),
}) => SearchingDriverViewModel(
  ride: testRide(),
  rideService: service,
  coordinator: coordinator ?? _FakeCoordinator(),
  pollInterval: pollInterval,
);

void main() {
  setUpAll(() => CityMap.debugDisableTiles = true);

  group('SearchingDriverViewModel', () {
    test('keeps searching until a driver is assigned', () async {
      final service = FakeRideService()
        ..fetchResults = [
          RideSuccess(testRide()),
          RideSuccess(
            testRide(status: RideStatus.driverAssigned, driver: _driver),
          ),
        ];
      final viewModel = _viewModel(service);

      await viewModel.poll();
      expect(viewModel.isSearching, isTrue);

      await viewModel.poll();
      expect(viewModel.isSearching, isFalse);
      expect(viewModel.driver!.name, 'Fernanda Alves');
      viewModel.dispose();
    });

    test('a failed poll keeps the ride and shows the message', () async {
      final service = FakeRideService()
        ..fetchResults = [const RideFailure('Sem conexão.')];
      final viewModel = _viewModel(service);

      await viewModel.poll();
      expect(viewModel.errorMessage, 'Sem conexão.');
      expect(viewModel.isSearching, isTrue);
      viewModel.dispose();
    });

    test('cancel asks the server', () async {
      final service = FakeRideService();
      final viewModel = _viewModel(service);

      expect(await viewModel.cancel(), isTrue);
      expect(service.cancelCalls, 1);
      expect(viewModel.status, RideStatus.cancelled);
      expect(viewModel.canCancel, isFalse);
      viewModel.dispose();
    });

    test('polls after dispose are ignored', () async {
      final service = FakeRideService();
      final viewModel = _viewModel(service)..dispose();
      await viewModel.poll();
      expect(service.fetchCalls, 0);
    });
  });

  group('SearchingDriverView', () {
    Future<void> pumpSearching(
      WidgetTester tester,
      SearchingDriverViewModel viewModel,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(app(SearchingDriverView(viewModel: viewModel)));
    }

    testWidgets('searches, then shows the driver', (tester) async {
      final service = FakeRideService()
        ..fetchResults = [
          RideSuccess(testRide()),
          RideSuccess(
            testRide(status: RideStatus.driverAssigned, driver: _driver),
          ),
        ];
      await pumpSearching(tester, _viewModel(service));

      expect(find.text('Procurando motorista'), findsOneWidget);
      expect(find.byKey(const Key('searching_progress')), findsOneWidget);

      // The pulse repeats forever: pump() with a duration, never
      // pumpAndSettle().
      await tester.pump(const Duration(seconds: 2));
      await tester.pump();
      expect(find.byKey(const Key('searching_driver')), findsNothing);

      await tester.pump(const Duration(seconds: 2));
      await tester.pump();
      expect(find.text('Motorista a caminho'), findsOneWidget);
      expect(find.byKey(const Key('searching_driver')), findsOneWidget);
      expect(find.text('BYD Dolphin Mini branco'), findsOneWidget);
      expect(find.text('Chega em 5 min'), findsOneWidget);
      expect(find.byKey(const Key('searching_progress')), findsNothing);

      // No more polls once the driver is known.
      final calls = service.fetchCalls;
      await tester.pump(const Duration(seconds: 6));
      expect(service.fetchCalls, calls);
    });

    testWidgets('cancel goes back home', (tester) async {
      final service = FakeRideService();
      final coordinator = _FakeCoordinator();
      await pumpSearching(
        tester,
        _viewModel(service, coordinator: coordinator),
      );

      await tester.tap(find.byKey(const Key('searching_cancel')));
      await tester.pump();

      expect(service.cancelCalls, 1);
      expect(coordinator.homes, 1);
    });

    testWidgets('the back button does not leave the screen', (tester) async {
      await pumpSearching(tester, _viewModel(FakeRideService()));

      expect(
        find.byWidgetPredicate((w) => w is PopScope && !w.canPop),
        findsOneWidget,
      );

      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      await navigator.maybePop();
      await tester.pump();
      expect(find.byType(SearchingDriverView), findsOneWidget);
    });
  });
}
