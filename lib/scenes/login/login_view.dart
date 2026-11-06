import 'package:fastmob_design_system/fastmob_design_system.dart';
import 'package:flutter/material.dart';

import 'login_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({required this.viewModel, super.key});

  final LoginViewModel viewModel;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final muted = context.semanticColors.muted;

    return AppScaffold(
      showAppBar: false,
      padded: false,
      safeAreaTop: false,
      body: SingleChildScrollView(
        child: AutofillGroup(
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const BrandHeader(
                  title: 'Chegue mais rápido.',
                  subtitle: 'Peça sua corrida em segundos, onde estiver.',
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Entrar', style: textTheme.headlineMedium),
                      const Gap.xs(),
                      Text(
                        'Use seu e-mail e senha para continuar.',
                        style: textTheme.bodyMedium?.copyWith(color: muted),
                      ),
                      const Gap.xl(),
                      AppTextField(
                        key: const Key('login_email'),
                        label: 'E-mail',
                        hint: 'voce@exemplo.com',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Icons.mail_outline,
                        autofillHints: const [AutofillHints.email],
                        onChanged: viewModel.onEmailChanged,
                      ),
                      const Gap.md(),
                      PasswordField(
                        key: const Key('login_password'),
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        onChanged: viewModel.onPasswordChanged,
                      ),
                      if (viewModel.errorMessage case final message?) ...[
                        const Gap.md(),
                        Text(
                          message,
                          key: const Key('login_error'),
                          style: textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const Gap.xl(),
                      AppButton(
                        key: const Key('login_submit'),
                        label: 'Entrar',
                        isLoading: viewModel.isLoading,
                        onPressed: () async {
                          final loggedIn = await viewModel.submit();
                          if (loggedIn && context.mounted) {
                            viewModel.openHome(context);
                          }
                        },
                      ),
                      if (viewModel.userName case final name?) ...[
                        const Gap.md(),
                        Text(
                          'Bem-vindo, $name!',
                          key: const Key('login_welcome'),
                          style: textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
