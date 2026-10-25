import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/language_menu.dart';
import '../../../../core/localization/localized_failure.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() => context.read<LoginCubit>().login(
    email: emailController.text,
    password: passwordController.text,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(actions: const [LanguageMenu()]),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) => Column(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 70,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      l10n.appTitle,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(l10n.userDirectory, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 35),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.login,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 25),
                          Text(l10n.email),
                          const SizedBox(height: 8),
                          TextField(
                            controller: emailController,
                            enabled: state is! LoginLoading,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            textDirection: TextDirection.ltr,
                            autofillHints: const [AutofillHints.username],
                            decoration: InputDecoration(
                              hintText: l10n.emailHint,
                              prefixIcon: const Icon(Icons.email_outlined),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(l10n.password),
                          const SizedBox(height: 8),
                          TextField(
                            controller: passwordController,
                            enabled: state is! LoginLoading,
                            obscureText: obscurePassword,
                            textDirection: TextDirection.ltr,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _login(),
                            autofillHints: const [AutofillHints.password],
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                tooltip: obscurePassword
                                    ? l10n.showPassword
                                    : l10n.hidePassword,
                                onPressed: () => setState(
                                  () => obscurePassword = !obscurePassword,
                                ),
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (state is LoginFailure)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(
                                state.failure.localize(l10n),
                                style: TextStyle(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                            ),
                          if (state is LoginLoading)
                            SizedBox(
                              height: 52,
                              child: Center(
                                child: CircularProgressIndicator(
                                  semanticsLabel: l10n.loading,
                                ),
                              ),
                            )
                          else
                            ElevatedButton(
                              onPressed: _login,
                              child: Text(l10n.login),
                            ),
                          const SizedBox(height: 20),
                          Text(
                            l10n.loginOfflineHint,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: state is LoginLoading
                                ? null
                                : () {
                                    emailController.text = 'eve.holt@reqres.in';
                                    passwordController.text = 'cityslicka';
                                  },
                            child: Text(l10n.useDemoAccount),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
