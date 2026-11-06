import 'package:fastmob_design_system/fastmob_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('RideOptionCard', () {
    Widget card({
      bool selected = false,
      bool eco = false,
      VoidCallback? onTap,
    }) => RideOptionCard(
      name: 'Fast',
      subtitle: 'Mais barato',
      priceCents: 1240,
      eta: '4 min',
      icon: Icons.directions_car_outlined,
      selected: selected,
      eco: eco,
      onTap: onTap ?? () {},
    );

    testWidgets('shows name, price and eta and reacts to taps', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(wrap(card(onTap: () => taps++)));

      expect(find.text('Fast'), findsOneWidget);
      expect(find.text(r'R$ 12,40'), findsOneWidget);
      expect(find.text('4 min'), findsOneWidget);

      await tester.tap(find.byType(RideOptionCard));
      expect(taps, 1);
    });

    testWidgets('has a descriptive accessibility label', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(wrap(card(selected: true)));

      expect(
        find.bySemanticsLabel(r'Fast, R$ 12,40, chega em 4 min'),
        findsOneWidget,
      );
      handle.dispose();
    });

    testWidgets('eco shows a leaf and says it is electric', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(wrap(card()));
      expect(find.byKey(const Key('ride_option_eco')), findsNothing);

      await tester.pumpWidget(wrap(card(eco: true)));
      expect(find.byKey(const Key('ride_option_eco')), findsOneWidget);
      expect(
        find.bySemanticsLabel(
          r'Fast, R$ 12,40, chega em 4 min, 100% elétrico',
        ),
        findsOneWidget,
      );
      handle.dispose();
    });
  });

  group('StatusChip', () {
    testWidgets('shows label and icon', (tester) async {
      await tester.pumpWidget(
        wrap(
          const StatusChip(
            label: 'A caminho',
            tone: StatusTone.info,
            icon: Icons.directions_car_outlined,
          ),
        ),
      );
      expect(find.text('A caminho'), findsOneWidget);
      expect(find.byIcon(Icons.directions_car_outlined), findsOneWidget);
    });

    testWidgets('builds every tone in both themes', (tester) async {
      for (final dark in [false, true]) {
        await tester.pumpWidget(
          wrap(
            dark: dark,
            Column(
              children: [
                for (final tone in StatusTone.values)
                  StatusChip(label: tone.name, tone: tone),
              ],
            ),
          ),
        );
        expect(find.byType(StatusChip), findsNWidgets(StatusTone.values.length));
      }
    });
  });

  group('LocationTile', () {
    testWidgets('shows title and subtitle and fires onTap', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        wrap(
          LocationTile(
            title: 'Aeroporto',
            subtitle: 'Av. NS 10',
            onTap: () => taps++,
          ),
        ),
      );
      expect(find.text('Aeroporto'), findsOneWidget);
      expect(find.text('Av. NS 10'), findsOneWidget);
      await tester.tap(find.text('Aeroporto'));
      expect(taps, 1);
    });

    testWidgets('builds each kind of marker', (tester) async {
      await tester.pumpWidget(
        wrap(
          Column(
            children: [
              for (final kind in LocationKind.values)
                LocationTile(title: kind.name, kind: kind),
            ],
          ),
        ),
      );
      expect(find.byType(LocationTile), findsNWidgets(3));
    });
  });

  group('DriverCard', () {
    testWidgets('shows driver, rating with comma, vehicle and plate', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const DriverCard(
            name: 'Carlos Souza',
            rating: 4.9,
            vehicle: 'Onix prata',
            plate: 'QWE-1A23',
          ),
        ),
      );
      expect(find.text('Carlos Souza'), findsOneWidget);
      expect(find.text('4,9'), findsOneWidget);
      expect(find.text('Onix prata'), findsOneWidget);
      expect(find.text('QWE-1A23'), findsOneWidget);
      expect(find.byIcon(Icons.call_outlined), findsNothing);
    });

    testWidgets('actions only appear when their callbacks are given', (
      tester,
    ) async {
      var calls = 0;
      await tester.pumpWidget(
        wrap(
          DriverCard(
            name: 'Carlos Souza',
            rating: 5,
            vehicle: 'Onix prata',
            plate: 'QWE-1A23',
            onCall: () => calls++,
          ),
        ),
      );
      expect(find.byIcon(Icons.chat_bubble_outline), findsNothing);
      await tester.tap(find.byIcon(Icons.call_outlined));
      expect(calls, 1);
    });
  });
}
