import 'package:fastmob_design_system/fastmob_design_system.dart';
import 'package:flutter/material.dart';

import '../../shared/format.dart';
import '../../shared/map/city_map.dart';
import '../../shared/rides/ride.dart';
import '../../shared/rides/ride_category_ui.dart';
import 'confirm_ride_view_model.dart';

class ConfirmRideView extends StatefulWidget {
  const ConfirmRideView({required this.viewModel, super.key});

  final ConfirmRideViewModel viewModel;

  @override
  State<ConfirmRideView> createState() => _ConfirmRideViewState();
}

class _ConfirmRideViewState extends State<ConfirmRideView> {
  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final draft = viewModel.draft;
    final size = MediaQuery.sizeOf(context);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CityMap(
              origin: draft.origin,
              destination: draft.destination,
              interactive: false,
              topInset: 64,
              bottomInset: size.height * 0.55,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: CircleAvatar(
                backgroundColor: scheme.surface,
                child: IconButton(
                  key: const Key('confirm_back'),
                  tooltip: 'Voltar',
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomPanel(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: size.height * 0.7),
                child: SingleChildScrollView(
                  child: ListenableBuilder(
                    listenable: viewModel,
                    builder: (context, _) => _Summary(viewModel: viewModel),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.viewModel});

  final ConfirmRideViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = context.semanticColors.muted;
    final draft = viewModel.draft;
    final quote = draft.quote;
    final category = quote.category;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Confirme sua corrida', style: theme.textTheme.titleLarge),
        const Gap.sm(),
        LocationTile(
          kind: LocationKind.origin,
          title: draft.origin.name,
          subtitle: draft.origin.address,
        ),
        LocationTile(
          title: draft.destination.name,
          subtitle: draft.destination.address,
        ),
        const EmptyDivider(),
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(category.icon, color: scheme.onPrimaryContainer),
            ),
            const Gap.md(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.label, style: theme.textTheme.titleMedium),
                  Text(
                    '${category.description} · motorista em '
                    '${formatEta(quote.etaSeconds)}',
                    style: theme.textTheme.bodySmall?.copyWith(color: muted),
                  ),
                  Text(
                    '${formatDistance(draft.estimate.distanceMeters)} · '
                    'cerca de ${formatEta(draft.estimate.durationSeconds)} '
                    'de viagem',
                    style: theme.textTheme.bodySmall?.copyWith(color: muted),
                  ),
                ],
              ),
            ),
            PriceText(
              key: const Key('confirm_price'),
              cents: quote.priceCents,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const Gap.md(),
        if (viewModel.isElectric)
          ImpactCard(
            key: const Key('confirm_impact'),
            icon: Icons.electric_car_outlined,
            title: 'Carro elétrico, zero emissão local',
            message: 'É o CO₂ que um carro a combustão soltaria nesta rota.',
            highlight: '${formatCo2(draft.co2AvoidedGrams)}\nevitados',
          )
        else
          ImpactCard(
            key: const Key('confirm_impact'),
            title: 'Carbono compensado',
            message: 'A FastMob compensa 100% das emissões desta corrida.',
            highlight: quote.co2Grams > 0 ? formatCo2(quote.co2Grams) : null,
          ),
        const SectionHeader(title: 'Pagamento'),
        SegmentedButton<PaymentMethod>(
          key: const Key('confirm_payment'),
          showSelectedIcon: false,
          segments: [
            for (final method in PaymentMethod.values)
              ButtonSegment(
                value: method,
                label: Text(method.label),
                icon: Icon(_paymentIcon(method)),
              ),
          ],
          selected: {viewModel.paymentMethod},
          onSelectionChanged: viewModel.isSubmitting
              ? null
              : (selection) => viewModel.selectPaymentMethod(selection.first),
        ),
        if (viewModel.errorMessage case final message?) ...[
          const Gap.md(),
          Text(
            message,
            key: const Key('confirm_error'),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: scheme.error),
          ),
        ],
        const Gap.lg(),
        AppButton(
          key: const Key('confirm_submit'),
          label: 'Confirmar corrida',
          isLoading: viewModel.isSubmitting,
          onPressed: () async {
            final requested = await viewModel.submit();
            if (requested && context.mounted) {
              viewModel.openSearching(context);
            }
          },
        ),
      ],
    );
  }

  static IconData _paymentIcon(PaymentMethod method) => switch (method) {
    PaymentMethod.pix => Icons.pix,
    PaymentMethod.card => Icons.credit_card,
    PaymentMethod.cash => Icons.payments_outlined,
  };
}
