import 'package:fastmob_design_system/fastmob_design_system.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class MobilityPage extends StatefulWidget {
  const MobilityPage({super.key});

  @override
  State<MobilityPage> createState() => _MobilityPageState();
}

class _MobilityPageState extends State<MobilityPage> {
  int _selected = 0;
  int _payment = 0;

  static const _options =
      <({String name, String sub, int cents, String eta, IconData icon, bool eco})>[
        (name: 'Fast', sub: 'Mais barato', cents: 1240, eta: '4 min', icon: Icons.directions_car_outlined, eco: false),
        (name: 'Eco', sub: '100% elétrico', cents: 1360, eta: '5 min', icon: Icons.electric_car_outlined, eco: true),
        (name: 'Conforto', sub: 'Carros novos', cents: 1790, eta: '6 min', icon: Icons.directions_car_filled_outlined, eco: false),
        (name: 'Moto', sub: 'Mais ágil', cents: 860, eta: '3 min', icon: Icons.two_wheeler_outlined, eco: false),
      ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Corrida',
      actions: const [ThemeModeButton()],
      body: ListView(
        children: [
          const SectionHeader(title: 'RideOptionCard'),
          SizedBox(
            height: 132,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _options.length,
              separatorBuilder: (_, _) => const Gap.sm(),
              itemBuilder: (context, i) {
                final o = _options[i];
                return RideOptionCard(
                  name: o.name,
                  subtitle: o.sub,
                  priceCents: o.cents,
                  eta: o.eta,
                  icon: o.icon,
                  eco: o.eco,
                  selected: i == _selected,
                  onTap: () => setState(() => _selected = i),
                );
              },
            ),
          ),
          const SectionHeader(title: 'ImpactCard'),
          const ImpactCard(
            title: 'Carro elétrico, zero emissão local',
            message: 'Comparado a um carro a combustão na mesma rota.',
            highlight: '2,1 kg de CO₂\nevitados',
            icon: Icons.electric_car_outlined,
          ),
          const Gap.sm(),
          const ImpactCard(
            title: 'Carbono compensado',
            message: 'A FastMob compensa 100% das emissões desta corrida.',
          ),
          const SectionHeader(title: 'SegmentedButton (tema)'),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('Pix'), icon: Icon(Icons.pix)),
              ButtonSegment(value: 1, label: Text('Cartão'), icon: Icon(Icons.credit_card)),
              ButtonSegment(value: 2, label: Text('Dinheiro'), icon: Icon(Icons.payments_outlined)),
            ],
            selected: {_payment},
            onSelectionChanged: (s) => setState(() => _payment = s.first),
          ),
          const SectionHeader(title: 'LocationTile'),
          const LocationTile(
            kind: LocationKind.origin,
            title: 'Meu local',
            subtitle: 'Quadra 104 Sul, Palmas',
          ),
          const LocationTile(
            kind: LocationKind.stop,
            title: 'Parada',
            subtitle: 'Praça dos Girassóis',
          ),
          LocationTile(
            title: 'Aeroporto de Palmas',
            subtitle: 'Av. NS 10',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const SectionHeader(title: 'StatusChip'),
          const Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              StatusChip(label: 'Procurando', icon: Icons.search),
              StatusChip(
                label: 'A caminho',
                tone: StatusTone.info,
                icon: Icons.directions_car_outlined,
              ),
              StatusChip(
                label: 'Confirmada',
                tone: StatusTone.success,
                icon: Icons.check_circle_outline,
              ),
              StatusChip(label: 'Aguardando', tone: StatusTone.warning),
              StatusChip(label: 'Cancelada', tone: StatusTone.danger),
            ],
          ),
          const SectionHeader(title: 'DriverCard'),
          DriverCard(
            name: 'Carlos Souza',
            rating: 4.9,
            vehicle: 'Onix prata',
            plate: 'QWE-1A23',
            onCall: () {},
            onMessage: () {},
          ),
          const SectionHeader(title: 'PriceText'),
          Text('R\$ 12,40  ·  ${PriceText.format(123456)}'),
          const Gap.xxl(),
        ],
      ),
    );
  }
}
