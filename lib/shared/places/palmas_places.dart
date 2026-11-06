import 'package:latlong2/latlong.dart';

import 'place.dart';

/// Local catalog of places in Palmas (TO), used while there is no real
/// geocoding.
///
/// The coordinates are approximate: check them on openstreetmap.org before a
/// demo.
abstract final class PalmasPlaces {
  /// City center, used when there is nothing better to center the map on.
  static const center = LatLng(-10.1844, -48.3336);

  /// Fixed pickup point until geolocation arrives (later sprint).
  static const myLocation = Place(
    id: 'my_location',
    name: 'Meu local',
    address: 'Quadra 104 Sul, Palmas',
    location: LatLng(-10.1893, -48.3295),
  );

  static const pracaDosGirassois = Place(
    id: 'praca_girassois',
    name: 'Praça dos Girassóis',
    address: 'Centro, Palmas',
    location: LatLng(-10.1844, -48.3336),
  );

  static const airport = Place(
    id: 'aeroporto',
    name: 'Aeroporto de Palmas',
    address: 'Av. Joaquim Teotônio Segurado, Palmas',
    location: LatLng(-10.2915, -48.3570),
  );

  static const cesamar = Place(
    id: 'cesamar',
    name: 'Parque Cesamar',
    address: 'Quadra 506 Sul, Palmas',
    location: LatLng(-10.2108, -48.3186),
  );

  static const uft = Place(
    id: 'uft',
    name: 'UFT, Câmpus Palmas',
    address: 'Quadra 109 Norte, Palmas',
    location: LatLng(-10.1797, -48.3604),
  );

  static const graciosa = Place(
    id: 'graciosa',
    name: 'Praia da Graciosa',
    address: 'Orla do lago, Palmas',
    location: LatLng(-10.1917, -48.3655),
  );

  static const capimDourado = Place(
    id: 'capim_dourado',
    name: 'Capim Dourado Shopping',
    address: 'Quadra 107 Norte, Palmas',
    location: LatLng(-10.1740, -48.3330),
  );

  static const destinations = <Place>[
    pracaDosGirassois,
    airport,
    cesamar,
    uft,
    graciosa,
    capimDourado,
  ];
}
