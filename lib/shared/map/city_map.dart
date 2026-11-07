import 'package:fastmob_design_system/fastmob_design_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../places/place.dart';

/// Free map of the city (OpenStreetMap tiles, no API key) with the pickup
/// point and, when there is one, the destination and a straight route.
///
/// The route is a straight line for now; a `RouteService` will draw the
/// streets in a later sprint.
///
/// OpenStreetMap tiles are fine for light use like a class project. For
/// production, the OSM tile policy asks for your own tile server or a
/// provider.
class CityMap extends StatelessWidget {
  const CityMap({
    required this.origin,
    super.key,
    this.destination,
    this.bottomInset = 0,
    this.topInset = 0,
    this.interactive = true,
    this.pulseOrigin = false,
    this.zoom = 14,
  });

  final Place origin;
  final Place? destination;

  /// Height covered by the bottom panel, so the route stays visible.
  final double bottomInset;

  /// Height covered by the top bar; the attribution goes right below it.
  final double topInset;
  final bool interactive;

  /// Animated ring around the pickup point (searching for a driver).
  final bool pulseOrigin;
  final double zoom;

  /// Tests set this to true: no tile layer, so no HTTP requests.
  @visibleForTesting
  static bool debugDisableTiles = false;

  static const tileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const userAgentPackageName = 'dev.fastmob.app';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final destination = this.destination;
    final flags = interactive
        ? InteractiveFlag.all & ~InteractiveFlag.rotate
        : InteractiveFlag.none;
    final interaction = InteractionOptions(flags: flags);

    // Either a center and zoom or a camera fit, never both.
    final options = destination == null
        ? MapOptions(
            initialCenter: origin.location,
            initialZoom: zoom,
            interactionOptions: interaction,
            backgroundColor: scheme.surfaceContainerHighest,
          )
        : MapOptions(
            initialCameraFit: CameraFit.bounds(
              bounds: LatLngBounds(origin.location, destination.location),
              padding: EdgeInsets.fromLTRB(
                48,
                topInset + 72,
                48,
                bottomInset + 48,
              ),
            ),
            interactionOptions: interaction,
            backgroundColor: scheme.surfaceContainerHighest,
          );

    return Stack(
      children: [
        Positioned.fill(
          child: FlutterMap(
            // A new destination rebuilds the map, which fits the new route.
            // No MapController needed.
            key: ValueKey('${origin.id}>${destination?.id}'),
            options: options,
            children: [
              if (!debugDisableTiles)
                TileLayer(
                  urlTemplate: tileUrl,
                  userAgentPackageName: userAgentPackageName,
                ),
              if (destination != null)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [origin.location, destination.location],
                      strokeWidth: 5,
                      color: scheme.primary,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: origin.location,
                    width: 72,
                    height: 72,
                    child: _OriginMarker(pulse: pulseOrigin),
                  ),
                  if (destination != null)
                    Marker(
                      point: destination.location,
                      width: 40,
                      height: 40,
                      // The tip of the pin sits on the point.
                      alignment: Alignment.topCenter,
                      child: Icon(
                        Icons.location_on,
                        size: 40,
                        color: scheme.primary,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        // The default attribution widget would sit under the bottom panel.
        Positioned(
          top: topInset,
          left: 0,
          right: 0,
          child: const SafeArea(
            bottom: false,
            child: Center(child: _Attribution()),
          ),
        ),
      ],
    );
  }
}

class _Attribution extends StatelessWidget {
  const _Attribution();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.85),
        borderRadius: AppRadius.pillAll,
      ),
      child: Text(
        '© OpenStreetMap',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: context.semanticColors.muted,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class _OriginMarker extends StatefulWidget {
  const _OriginMarker({required this.pulse});

  final bool pulse;

  @override
  State<_OriginMarker> createState() => _OriginMarkerState();
}

class _OriginMarkerState extends State<_OriginMarker>
    with SingleTickerProviderStateMixin {
  // Repeats forever: tests of screens with a pulse use pump(), not
  // pumpAndSettle().
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void initState() {
    super.initState();
    if (widget.pulse) _controller.repeat();
  }

  @override
  void didUpdateWidget(_OriginMarker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pulse && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.pulse && _controller.isAnimating) {
      _controller
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dot = Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: scheme.primary,
        shape: BoxShape.circle,
        border: Border.all(color: scheme.surface, width: 3),
        boxShadow: const [
          BoxShadow(color: Color(0x40000000), blurRadius: 6),
        ],
      ),
    );
    if (!widget.pulse) return Center(child: dot);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 20 + 52 * t,
              height: 20 + 52 * t,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.primary.withValues(alpha: 0.35 * (1 - t)),
              ),
            ),
            child!,
          ],
        );
      },
      child: dot,
    );
  }
}
