import 'package:fastmob/scenes/home/home_view_model.dart';
import 'package:fastmob/shared/places/palmas_places.dart';
import 'package:fastmob/shared/places/place_search.dart';
import 'package:fastmob/shared/rides/ride_category.dart';
import 'package:fastmob/shared/rides/ride_estimator.dart';
import 'package:fastmob/scenes/home/home_coordinator.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes.dart';

HomeViewModel _viewModel({HomeCoordinator? coordinator}) => HomeViewModel(
  placeSearch: const DefaultPlaceSearch(),
  estimator: const DefaultRideEstimator(),
  coordinator: coordinator ?? FakeHomeCoordinator(),
);

void main() {
  test('starts with the suggestions and no destination', () async {
    final viewModel = _viewModel();
    await pumpEventQueue();

    expect(viewModel.results, PalmasPlaces.destinations);
    expect(viewModel.destination, isNull);
    expect(viewModel.canContinue, isFalse);
  });

  test('typing filters the places', () async {
    final viewModel = _viewModel();
    await viewModel.onQueryChanged('aeroporto');
    expect(viewModel.results, [PalmasPlaces.airport]);
  });

  test('choosing a destination estimates and preselects Fast', () async {
    final viewModel = _viewModel();
    final future = viewModel.selectDestination(PalmasPlaces.airport);
    expect(viewModel.isEstimating, isTrue);
    expect(viewModel.canContinue, isFalse);
    await future;

    expect(viewModel.isEstimating, isFalse);
    expect(viewModel.quotes, hasLength(RideCategory.values.length));
    expect(viewModel.selectedQuote!.category, RideCategory.fast);
    expect(viewModel.canContinue, isTrue);
  });

  test('selecting a quote changes the draft', () async {
    final viewModel = _viewModel();
    await viewModel.selectDestination(PalmasPlaces.cesamar);
    final eco = viewModel.estimate!.quoteFor(RideCategory.eco)!;
    viewModel.selectQuote(eco);

    final draft = viewModel.draft!;
    expect(draft.quote.category, RideCategory.eco);
    expect(draft.origin, PalmasPlaces.myLocation);
    expect(draft.destination, PalmasPlaces.cesamar);
  });

  test('clearing the destination goes back to the search', () async {
    final viewModel = _viewModel();
    await viewModel.onQueryChanged('uft');
    await viewModel.selectDestination(PalmasPlaces.uft);
    viewModel.clearDestination();
    await pumpEventQueue();

    expect(viewModel.destination, isNull);
    expect(viewModel.draft, isNull);
    expect(viewModel.query, isEmpty);
    expect(viewModel.results, PalmasPlaces.destinations);
  });
}
