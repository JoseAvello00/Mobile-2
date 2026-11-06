import 'package:fastmob_design_system/fastmob_design_system.dart';
import 'package:flutter/material.dart';

import '../../shared/format.dart';
import '../../shared/map/city_map.dart';
import '../../shared/places/place.dart';
import '../../shared/rides/ride_category_ui.dart';
import 'home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({required this.viewModel, super.key});

  final HomeViewModel viewModel;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) => Stack(
          children: [
            Positioned.fill(
              child: CityMap(
                origin: viewModel.origin,
                destination: viewModel.destination,
                topInset: 64,
                bottomInset: size.height * 0.5,
              ),
            ),
            const _TopBar(),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomPanel(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: size.height * 0.6),
                  child: SingleChildScrollView(
                    child: viewModel.destination == null
                        ? _DestinationSearch(viewModel: viewModel)
                        : _RideChoice(viewModel: viewModel),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: AppRadius.pillAll,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const FastMobLogo(size: 24),
            ),
            CircleAvatar(
              backgroundColor: scheme.surface,
              child: IconButton(
                tooltip: 'Perfil',
                onPressed: () {},
                icon: const Icon(Icons.person_outline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// No destination yet: search field and suggestions.
class _DestinationSearch extends StatelessWidget {
  const _DestinationSearch({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final results = viewModel.results;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Para onde vamos?', style: theme.textTheme.titleLarge),
        const Gap.md(),
        AppTextField(
          key: const Key('home_destination'),
          label: 'Destino',
          hint: 'Busque um lugar em Palmas',
          prefixIcon: Icons.search,
          textInputAction: TextInputAction.search,
          onChanged: viewModel.onQueryChanged,
        ),
        SectionHeader(
          title: viewModel.query.trim().isEmpty ? 'Sugestões' : 'Resultados',
        ),
        if (results.isEmpty)
          Padding(
            key: const Key('home_no_results'),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Text(
              'Nenhum lugar encontrado em Palmas.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.semanticColors.muted,
              ),
            ),
          ),
        for (final place in results)
          LocationTile(
            key: Key('place_${place.id}'),
            title: place.name,
            subtitle: place.address,
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              FocusScope.of(context).unfocus();
              viewModel.selectDestination(place);
            },
          ),
      ],
    );
  }
}

/// Destination chosen: trip summary, categories and "Continuar".
class _RideChoice extends StatelessWidget {
  const _RideChoice({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final destination = viewModel.destination!;
    final estimate = viewModel.estimate;
    final selected = viewModel.selectedQuote;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Route(
          origin: viewModel.origin,
          destination: destination,
          onClear: viewModel.clearDestination,
        ),
        const Gap.sm(),
        Row(
          children: [
            Expanded(
              child: Text('Escolha sua corrida', style: theme.textTheme.titleMedium),
            ),
            if (estimate != null)
              Text(
                '${formatDistance(estimate.distanceMeters)} · '
                '${formatEta(estimate.durationSeconds)}',
                key: const Key('home_trip_summary'),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: context.semanticColors.muted,
                ),
              ),
          ],
        ),
        const Gap.md(),
        if (viewModel.isEstimating)
          const SizedBox(
            height: 132,
            child: Center(child: CircularProgressIndicator()),
          )
        else
          SizedBox(
            height: 132,
            child: ListView.separated(
              key: const Key('ride_options'),
              scrollDirection: Axis.horizontal,
              itemCount: viewModel.quotes.length,
              separatorBuilder: (_, _) => const Gap.sm(),
              itemBuilder: (context, index) {
                final quote = viewModel.quotes[index];
                final category = quote.category;
                return RideOptionCard(
                  key: Key('ride_${category.apiValue}'),
                  name: category.label,
                  subtitle: category.description,
                  priceCents: quote.priceCents,
                  eta: formatEta(quote.etaSeconds),
                  icon: category.icon,
                  eco: category.isElectric,
                  selected: quote.category == selected?.category,
                  onTap: () => viewModel.selectQuote(quote),
                );
              },
            ),
          ),
        const Gap.lg(),
        AppButton(
          key: const Key('home_continue'),
          label: selected == null
              ? 'Escolha uma opção'
              : 'Continuar com ${selected.category.label}',
          onPressed: viewModel.canContinue
              ? () => viewModel.continueToConfirm(context)
              : null,
        ),
      ],
    );
  }
}

class _Route extends StatelessWidget {
  const _Route({
    required this.origin,
    required this.destination,
    required this.onClear,
  });

  final Place origin;
  final Place destination;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LocationTile(
          kind: LocationKind.origin,
          title: origin.name,
          subtitle: origin.address,
        ),
        LocationTile(
          key: const Key('home_selected_destination'),
          title: destination.name,
          subtitle: destination.address,
          trailing: IconButton(
            key: const Key('home_clear_destination'),
            tooltip: 'Trocar destino',
            onPressed: onClear,
            icon: const Icon(Icons.close),
          ),
        ),
      ],
    );
  }
}
