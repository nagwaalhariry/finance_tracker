import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
