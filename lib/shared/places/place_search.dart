import 'palmas_places.dart';
import 'place.dart';

/// Finds destinations from what the passenger typed.
abstract interface class PlaceSearch {
  /// An empty [query] returns the suggestions.
  Future<List<Place>> search(String query);
}

/// [PlaceSearch] over a local catalog, ignoring case and accents.
///
/// A real implementation could call Nominatim (OpenStreetMap); that service
/// asks for at most one request per second and an identifying User-Agent.
class DefaultPlaceSearch implements PlaceSearch {
  const DefaultPlaceSearch({this.places = PalmasPlaces.destinations});

  final List<Place> places;

  @override
  Future<List<Place>> search(String query) async {
    final terms = normalize(query).split(' ').where((t) => t.isNotEmpty);
    if (terms.isEmpty) return List.unmodifiable(places);
    return List.unmodifiable(
      places.where((place) {
        final text = normalize('${place.name} ${place.address}');
        return terms.every(text.contains);
      }),
    );
  }

  static const _accents = {
    'á': 'a', 'à': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a',
    'é': 'e', 'ê': 'e', 'è': 'e', 'ë': 'e',
    'í': 'i', 'î': 'i', 'ì': 'i', 'ï': 'i',
    'ó': 'o', 'ô': 'o', 'õ': 'o', 'ò': 'o', 'ö': 'o',
    'ú': 'u', 'û': 'u', 'ù': 'u', 'ü': 'u',
    'ç': 'c',
  };

  /// Lower case, no accents, single spaces: "Praça  dos GIRASSÓIS" ->
  /// "praca dos girassois".
  static String normalize(String text) {
    final buffer = StringBuffer();
    for (final char in text.toLowerCase().split('')) {
      buffer.write(_accents[char] ?? char);
    }
    return buffer.toString().trim().replaceAll(RegExp(r'\s+'), ' ');
  }
}
