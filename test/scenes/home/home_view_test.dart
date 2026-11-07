import 'package:fastmob/scenes/home/home_factory.dart';
import 'package:fastmob/scenes/home/home_view.dart';
import 'package:fastmob/scenes/home/home_view_model.dart';
import 'package:fastmob/shared/map/city_map.dart';
import 'package:fastmob/shared/places/place_search.dart';
import 'package:fastmob/shared/rides/ride_category.dart';
import 'package:fastmob/shared/rides/ride_estimator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes.dart';

void main() {
  setUpAll(() => CityMap.debugDisableTiles = true);

  late FakeHomeCoordinator coordinator;

  Future<void> pumpHome(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    coordinator = FakeHomeCoordinator();
    await tester.pumpWidget(
      app(
        HomeView(
          viewModel: HomeViewModel(
            placeSearch: const DefaultPlaceSearch(),
            estimator: const DefaultRideEstimator(),
            coordinator: coordinator,
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('HomeFactory.make builds the home with a map', (tester) async {
    await tester.pumpWidget(app(HomeFactory.make()));
    await tester.pump();
    expect(find.byType(HomeView), findsOneWidget);
    expect(find.byType(CityMap), findsOneWidget);
    expect(find.text('© OpenStreetMap'), findsOneWidget);
  });

  testWidgets('shows the search and the Palmas suggestions', (tester) async {
    await pumpHome(tester);

    expect(find.byKey(const Key('home_destination')), findsOneWidget);
    expect(find.byKey(const Key('place_aeroporto')), findsOneWidget);
    expect(find.byKey(const Key('place_praca_girassois')), findsOneWidget);
  });

  testWidgets('typing filters the suggestions', (tester) async {
    await pumpHome(tester);

    await tester.enterText(find.byKey(const Key('home_destination')), 'cesamar');
    await tester.pump();

    expect(find.byKey(const Key('place_cesamar')), findsOneWidget);
    expect(find.byKey(const Key('place_aeroporto')), findsNothing);

    await tester.enterText(find.byKey(const Key('home_destination')), 'xyz');
    await tester.pump();
    expect(find.byKey(const Key('home_no_results')), findsOneWidget);
  });

  testWidgets('picking a place shows the categories, Eco included', (
    tester,
  ) async {
    await pumpHome(tester);

    await tester.tap(find.byKey(const Key('place_aeroporto')));
    await tester.pump();
    await tester.pump();

    expect(find.byKey(const Key('home_selected_destination')), findsOneWidget);
    for (final category in RideCategory.values) {
      expect(find.byKey(Key('ride_${category.apiValue}')), findsOneWidget);
    }
    expect(find.byKey(const Key('ride_option_eco')), findsOneWidget);
    expect(find.text('Continuar com Fast'), findsOneWidget);
  });

  testWidgets('continue hands the chosen draft to the coordinator', (
    tester,
  ) async {
    await pumpHome(tester);
    await tester.tap(find.byKey(const Key('place_cesamar')));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.byKey(const Key('ride_eco')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('home_continue')));

    expect(coordinator.shown!.quote.category, RideCategory.eco);
    expect(coordinator.shown!.destination.id, 'cesamar');
  });

  testWidgets('the close button clears the destination', (tester) async {
    await pumpHome(tester);
    await tester.tap(find.byKey(const Key('place_uft')));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.byKey(const Key('home_clear_destination')));
    await tester.pump();
    await tester.pump();

    expect(find.byKey(const Key('home_destination')), findsOneWidget);
    expect(find.byKey(const Key('home_continue')), findsNothing);
  });
}
