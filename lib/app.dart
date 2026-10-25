import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'core/localization/locale_cubit.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/cubit/login_cubit.dart';
import 'features/auth/presentation/cubit/login_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/users/presentation/cubit/users_cubit.dart';
import 'features/users/presentation/pages/users_page.dart';
import 'l10n/generated/app_localizations.dart';

class AmanosApp extends StatelessWidget {
  const AmanosApp({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => getIt<LocaleCubit>()),
      BlocProvider(create: (_) => getIt<LoginCubit>()..restoreSession()),
    ],
    child: BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) => MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.lightTheme,
        home: const _SessionGate(),
      ),
    ),
  );
}

class _SessionGate extends StatelessWidget {
  const _SessionGate();

  @override
  Widget build(BuildContext context) => BlocBuilder<LoginCubit, LoginState>(
    builder: (context, state) {
      if (state is LoginCheckingSession) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              semanticsLabel: AppLocalizations.of(context)!.checkingSession,
            ),
          ),
        );
      }
      if (state is LoginSuccess) {
        return BlocProvider(
          create: (_) => getIt<UsersCubit>()..loadPage(1),
          child: UsersPage(onLogout: context.read<LoginCubit>().logout),
        );
      }
      return const LoginPage();
    },
  );
}
