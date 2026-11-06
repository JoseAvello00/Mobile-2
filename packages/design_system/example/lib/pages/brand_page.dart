import 'package:fastmob_design_system/fastmob_design_system.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class BrandPage extends StatelessWidget {
  const BrandPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Marca',
      actions: const [ThemeModeButton()],
      body: ListView(
        children: [
          const SectionHeader(title: 'FastMobLogo'),
          const FastMobLogo(),
          const Gap.lg(),
          const FastMobLogo(size: 32),
          const Gap.lg(),
          const FastMobLogo(size: 40, showWordmark: false),
          const SectionHeader(title: 'Sobre o laranja (onBrand)'),
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              gradient: context.semanticColors.brandGradient,
              borderRadius: AppRadius.lgAll,
            ),
            child: const FastMobLogo(onBrand: true),
          ),
          const SectionHeader(title: 'BrandHeader'),
          const ClipRRect(
            borderRadius: AppRadius.lgAll,
            child: SizedBox(
              height: 260,
              child: BrandHeader(
                title: 'Chegue mais rápido.',
                subtitle: 'Peça sua corrida em segundos, onde estiver.',
              ),
            ),
          ),
          const Gap.xxl(),
        ],
      ),
    );
  }
}
