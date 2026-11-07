import 'package:latlong2/latlong.dart';

/// A point the passenger can ride from or to.
class Place {
  const Place({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
  });

  final String id;
  final String name;
  final String address;
  final LatLng location;

  @override
  bool operator ==(Object other) => other is Place && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Place($id)';
}
