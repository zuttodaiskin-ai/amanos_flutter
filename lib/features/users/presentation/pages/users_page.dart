import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/language_menu.dart';
import '../../../../core/localization/localized_failure.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/app_user.dart';
import '../cubit/users_cubit.dart';
import '../cubit/users_state.dart';

class UsersPage extends StatefulWidget {
  final Future<void> Function() onLogout;
  const UsersPage({super.key, required this.onLogout});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  bool loggingOut = false;

  Future<void> _logout() async {
    setState(() => loggingOut = true);
    try {
      await widget.onLogout();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.logoutFailed)),
        );
      }
    } finally {
      if (mounted) setState(() => loggingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.users),
        actions: [
          const LanguageMenu(),
          IconButton(
            tooltip: l10n.refresh,
            onPressed: () => context.read<UsersCubit>().refresh(),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: l10n.logout,
            onPressed: loggingOut ? null : _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<UsersCubit, UsersState>(
          builder: (context, state) {
            final result = state.result;
            if (result == null && state.isLoading) {
              return Center(
                child: CircularProgressIndicator(semanticsLabel: l10n.loading),
              );
            }
            if (result == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.error?.localize(l10n) ?? l10n.noData,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<UsersCubit>().loadPage(
                          state.requestedPage,
                        ),
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                ),
              );
            }
            final page = result.data;
            return Column(
              children: [
                if (state.isLoading)
                  LinearProgressIndicator(semanticsLabel: l10n.loading),
                if (result.isFromCache)
                  _Notice(icon: Icons.cloud_off, message: l10n.cachedData),
                if (result.cacheWriteFailed)
                  _Notice(
                    icon: Icons.warning_amber,
                    message: l10n.cacheWriteFailed,
                  ),
                if (state.error != null)
                  _Notice(
                    icon: Icons.error_outline,
                    message: state.error!.localize(l10n),
                    onRetry: () => context.read<UsersCubit>().loadPage(
                      state.requestedPage,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(l10n.totalUsers(page.total)),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => context.read<UsersCubit>().refresh(),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: page.users.isEmpty ? 1 : page.users.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) => page.users.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                l10n.noUsers,
                                textAlign: TextAlign.center,
                              ),
                            )
                          : _UserCard(user: page.users[index]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: state.isLoading || page.page <= 1
                              ? null
                              : () => context.read<UsersCubit>().loadPage(
                                  page.page - 1,
                                ),
                          child: Text(l10n.previous),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          l10n.pageIndicator(page.page, page.totalPages),
                        ),
                      ),
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              state.isLoading || page.page >= page.totalPages
                              ? null
                              : () => context.read<UsersCubit>().loadPage(
                                  page.page + 1,
                                ),
                          child: Text(l10n.next),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final AppUser user;
  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      contentPadding: const EdgeInsets.all(12),
      leading: ClipOval(
        child: Image.network(
          user.avatar,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const SizedBox(
            width: 48,
            height: 48,
            child: Icon(Icons.person_outline),
          ),
        ),
      ),
      title: Text(user.fullName),
      subtitle: Text(user.email, textDirection: TextDirection.ltr),
      trailing: IconButton(
        tooltip: AppLocalizations.of(context)!.userDetails,
        icon: const Icon(Icons.info_outline),
        onPressed: () => showDialog<void>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(user.fullName),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(dialogContext)!.userId(user.id)),
                Text(user.email, textDirection: TextDirection.ltr),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(AppLocalizations.of(dialogContext)!.close),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _Notice extends StatelessWidget {
  final IconData icon;
  final String message;
  final VoidCallback? onRetry;
  const _Notice({required this.icon, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    padding: const EdgeInsets.all(12),
    child: Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Expanded(child: Text(message)),
        if (onRetry != null)
          TextButton(
            onPressed: onRetry,
            child: Text(AppLocalizations.of(context)!.retry),
          ),
      ],
    ),
  );
}
