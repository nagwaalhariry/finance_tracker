import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../expenses/presentation/cubit/dashboard_cubit.dart';
import '../../../profile/presentation/cubit/user_profile_cubit.dart';
import '../../../profile/presentation/pages/profile_setup_page.dart';
import '../cubit/auth_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (!state.isAuthenticated && context.mounted) {
            Navigator.of(context).popUntil((route) => route.isFirst);
            return;
          }
          if (state.status == AuthStatus.error && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                child: Row(
                  children: [
                    const CircleAvatar(radius: 26, child: Icon(Icons.person_outline)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Profile', style: TextStyle(fontWeight: FontWeight.w600)),
                          Text(
                            FirebaseAuth.instance.currentUser?.email ?? 'No email',
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<UserProfileCubit, UserProfileState>(
                builder: (context, state) {
                  final profile = state.profile;
                  final subtitle = profile == null
                      ? 'Not configured yet'
                      : '${NumberFormat.simpleCurrency(name: profile.currency).format(profile.monthlySalary)} • ${profile.currency}';
                  return AppCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Monthly Salary & Currency'),
                      subtitle: Text(subtitle),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        final profileCubit = context.read<UserProfileCubit>();
                        final updated = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: profileCubit,
                              child: const ProfileSetupPage(),
                            ),
                          ),
                        );
                        if (updated == true && context.mounted) {
                          await context.read<DashboardCubit>().loadDashboard();
                        }
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () async {
                  await context.read<AuthCubit>().signOut();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                onPressed: () async {
                  final shouldDelete = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Delete Account'),
                      content: const Text(
                        'This will permanently delete your Firebase account. Continue?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if (shouldDelete == true && context.mounted) {
                    await context.read<AuthCubit>().deleteAccount();
                  }
                },
                icon: const Icon(Icons.delete_forever),
                label: const Text('Delete Account'),
              ),
              const SizedBox(height: 8),
              const Text(
                'If account deletion fails, Firebase may require recent login. '
                'In that case, login again and retry.',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
