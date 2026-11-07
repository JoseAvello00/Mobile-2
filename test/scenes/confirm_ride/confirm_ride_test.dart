import 'package:fastmob/scenes/confirm_ride/confirm_ride_coordinator.dart';
import 'package:fastmob/scenes/confirm_ride/confirm_ride_factory.dart';
import 'package:fastmob/scenes/confirm_ride/confirm_ride_view.dart';
import 'package:fastmob/scenes/confirm_ride/confirm_ride_view_model.dart';
import 'package:fastmob/shared/map/city_map.dart';
import 'package:fastmob/shared/rides/ride.dart';
import 'package:fastmob/shared/rides/ride_category.dart';
import 'package:fastmob/shared/rides/ride_result.dart';
import 'package:fastmob_design_system/fastmob_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes.dart';

class _FakeCoordinator implements ConfirmRideCoordinator {
  Ride? shown;

  @override
  void showSearchingDriver(BuildContext context, Ride ride) => shown = ride;
}

void main() {
  setUpAll(() => CityMap.debugDisableTiles = true);

  group('ConfirmRideViewModel', () {
    test('defaults to Pix and sends the chosen method', () async {
      final service = FakeRideService();
      final viewModel = ConfirmRideViewModel(
        draft: testDraft(),
        rideService: service,
        coordinator: _FakeCoordinator(),
      );
      expect(viewModel.paymentMethod, PaymentMethod.pix);

      viewModel.selectPaymentMethod(PaymentMethod.cash);
      expect(await viewModel.submit(), isTrue);
      expect(service.lastPaymentMethod, PaymentMethod.cash);
      expect(viewModel.ride, isNotNull);
    });

    test('a failure shows its message and returns false', () async {
      final service = FakeRideService()
        ..requestResult = const RideFailure('Sem sinal.');
      final viewModel = ConfirmRideViewModel(
        draft: testDraft(),
        rideService: service,
        coordinator: _FakeCoordinator(),
      );
      expect(await viewModel.submit(), isFalse);
      expect(viewModel.errorMessage, 'Sem sinal.');
      expect(viewModel.isSubmitting, isFalse);
    });
  });

  group('ConfirmRideView', () {
    Future<_FakeCoordinator> pumpConfirm(
      WidgetTester tester, {
      RideCategory category = RideCategory.fast,
      FakeRideService? service,
    }) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final coordinator = _FakeCoordinator();
      await tester.pumpWidget(
        app(
          ConfirmRideView(
            viewModel: ConfirmRideViewModel(
              draft: testDraft(category: category),
              rideService: service ?? FakeRideService(),
              coordinator: coordinator,
            ),
          ),
        ),
      );
      return coordinator;
    }

    testWidgets('factory builds the scene', (tester) async {
      await tester.pumpWidget(
        app(
          ConfirmRideFactory.make(
            draft: testDraft(),
            rideService: FakeRideService(),
          ),
        ),
      );
      expect(find.byType(ConfirmRideView), findsOneWidget);
    });

    testWidgets('shows route, price and carbon offset for Fast', (
      tester,
    ) async {
      await pumpConfirm(tester);

      expect(find.text('Meu local'), findsOneWidget);
      expect(find.text('Aeroporto de Palmas'), findsOneWidget);
      expect(find.text(r'R$ 32,70'), findsOneWidget);
      expect(find.text('Carbono compensado'), findsOneWidget);
      expect(find.text('2,1 kg'), findsOneWidget);
    });

    testWidgets('Eco shows zero emission and CO₂ avoided', (tester) async {
      await pumpConfirm(tester, category: RideCategory.eco);

      expect(find.text('Carro elétrico, zero emissão local'), findsOneWidget);
      // 150 g/km * 14.2 km = 2130 g.
      expect(find.text('2,1 kg\nevitados'), findsOneWidget);
    });

    testWidgets('confirming requests the ride and opens the search', (
      tester,
    ) async {
      final service = FakeRideService();
      final coordinator = await pumpConfirm(tester, service: service);

      await tester.tap(find.text('Cartão'));
      await tester.pump();
      final segmented = tester.widget<SegmentedButton<PaymentMethod>>(
        find.byKey(const Key('confirm_payment')),
      );
      expect(segmented.selected, {PaymentMethod.card});

      await tester.tap(find.byKey(const Key('confirm_submit')));
      await tester.pump();

      expect(service.requestCalls, 1);
      expect(service.lastPaymentMethod, PaymentMethod.card);
      expect(coordinator.shown, isNotNull);
    });

    testWidgets('shows the error when the request fails', (tester) async {
      final service = FakeRideService()
        ..requestResult = const RideFailure('Categoria indisponível.');
      final coordinator = await pumpConfirm(tester, service: service);

      await tester.tap(find.byKey(const Key('confirm_submit')));
      await tester.pump();

      expect(find.text('Categoria indisponível.'), findsOneWidget);
      expect(coordinator.shown, isNull);
      expect(
        tester.widget<AppButton>(find.byKey(const Key('confirm_submit'))).isLoading,
        isFalse,
      );
    });
  });
}
