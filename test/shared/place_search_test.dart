import 'package:fastmob/shared/places/palmas_places.dart';
import 'package:fastmob/shared/places/place_search.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const search = DefaultPlaceSearch();

  test('an empty query returns every suggestion', () async {
    expect(await search.search('  '), PalmasPlaces.destinations);
  });

  test('ignores case and accents', () async {
    final results = await search.search('PRACA girassois');
    expect(results, [PalmasPlaces.pracaDosGirassois]);
  });

  test('matches the address too', () async {
    final results = await search.search('107 norte');
    expect(results, [PalmasPlaces.capimDourado]);
  });

  test('returns nothing for an unknown place', () async {
    expect(await search.search('Copacabana'), isEmpty);
  });

  test('normalize', () {
    expect(
      DefaultPlaceSearch.normalize('  Câmpus  da UFT '),
      'campus da uft',
    );
  });
}
