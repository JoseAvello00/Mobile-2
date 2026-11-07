import 'package:fastmob_design_system/fastmob_design_system.dart';
import 'package:flutter/material.dart';

import '../../shared/format.dart';
import '../../shared/map/city_map.dart';
import '../../shared/rides/ride.dart';
import 'searching_driver_view_model.dart';

class SearchingDriverView extends StatefulWidget {
  const SearchingDriverView({required this.viewModel, super.key});

  final SearchingDriverViewModel viewModel;

  @override
  State<SearchingDriverView> createState() => _SearchingDriverViewState();
}

class _SearchingDriverViewState extends State<SearchingDriverView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.start();
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final size = MediaQuery.sizeOf(context);

    // Leaving only through "Cancelar corrida", which tells the server.
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) => Stack(
            children: [
              Positioned.fill(
                child: CityMap(
                  origin: viewModel.ride.origin,
                  interactive: false,
                  pulseOrigin: viewModel.isSearching,
                  zoom: 15,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: BottomPanel(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: size.height * 0.6),
                    child: SingleChildScrollView(
                      child: _Status(viewModel: viewModel),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Status extends StatelessWidget {
  const _Status({required this.viewModel});

  final SearchingDriverViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = context.semanticColors.muted;
    final ride = viewModel.ride;
    final driver = viewModel.driver;

    final Widget header = switch (ride.status) {
      RideStatus.searching => const StatusChip(
        key: Key('searching_status'),
        label: 'Procurando motorista',
        icon: Icons.search,
      ),
      RideStatus.noDriver => const StatusChip(
        key: Key('searching_status'),
        label: 'Sem motoristas',
        tone: StatusTone.warning,
        icon: Icons.info_outline,
      ),
      RideStatus.cancelled => const StatusChip(
        key: Key('searching_status'),
        label: 'Cancelada',
        tone: StatusTone.danger,
        icon: Icons.close,
      ),
      _ => const StatusChip(
        key: Key('searching_status'),
        label: 'Motorista a caminho',
        tone: StatusTone.info,
        icon: Icons.directions_car_outlined,
      ),
    };

    final title = switch (ride.status) {
      RideStatus.searching => 'Procurando um motorista perto de você',
      RideStatus.noDriver => 'Nenhum motorista aceitou a tempo',
      RideStatus.cancelled => 'Corrida cancelada',
      _ => 'Seu motorista está a caminho',
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(alignment: Alignment.centerLeft, child: header),
        const Gap.md(),
        Text(title, style: theme.textTheme.titleLarge),
        const Gap.xs(),
        Text(
          '${ride.category.label} para ${ride.destination.name} · '
          '${PriceText.format(ride.priceCents)} · ${ride.paymentMethod.label}',
          style: theme.textTheme.bodyMedium?.copyWith(color: muted),
        ),
        const Gap.lg(),
        if (viewModel.isSearching)
          const ClipRRect(
            borderRadius: AppRadius.pillAll,
            child: LinearProgressIndicator(
              key: Key('searching_progress'),
              minHeight: 6,
            ),
          ),
        if (driver != null) ...[
          DriverCard(
            key: const Key('searching_driver'),
            name: driver.name,
            rating: driver.rating,
            vehicle: driver.vehicle,
            plate: driver.plate,
            imageUrl: driver.photoUrl,
          ),
          if (ride.etaSeconds case final eta?) ...[
            const Gap.sm(),
            Text(
              'Chega em ${formatEta(eta)}',
              key: const Key('searching_eta'),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall,
            ),
          ],
        ],
        if (viewModel.errorMessage case final message?) ...[
          const Gap.md(),
          Text(
            message,
            key: const Key('searching_error'),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
        const Gap.lg(),
        if (ride.status.isCancellable)
          AppButton.secondary(
            key: const Key('searching_cancel'),
            label: 'Cancelar corrida',
            icon: Icons.close,
            isLoading: viewModel.isCancelling,
            onPressed: () async {
              final cancelled = await viewModel.cancel();
              if (cancelled && context.mounted) viewModel.openHome(context);
            },
          )
        else
          AppButton(
            key: const Key('searching_home'),
            label: 'Voltar ao início',
            onPressed: () => viewModel.openHome(context),
          ),
      ],
    );
  }
}
