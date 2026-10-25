import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/generated/app_localizations.dart';
import 'locale_cubit.dart';

class LanguageMenu extends StatelessWidget {
  const LanguageMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopupMenuButton<Locale>(
      tooltip: l10n.changeLanguage,
      icon: const Icon(Icons.language),
      initialValue: context.watch<LocaleCubit>().state,
      onSelected: (locale) async {
        try {
          await context.read<LocaleCubit>().setLocale(locale);
        } catch (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.languageSaveFailed),
              ),
            );
          }
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(value: const Locale('ar'), child: Text(l10n.arabic)),
        PopupMenuItem(value: const Locale('en'), child: Text(l10n.english)),
      ],
    );
  }
}
