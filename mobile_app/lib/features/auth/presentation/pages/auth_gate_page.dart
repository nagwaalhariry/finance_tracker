import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection.dart';
import '../../../expenses/presentation/cubit/add_expense_cubit.dart';
import '../../../expenses/presentation/cubit/dashboard_cubit.dart';
import '../../../expenses/presentation/cubit/expense_cubit.dart';
import '../../../expenses/presentation/cubit/sync_cubit.dart';
import '../../../expenses/presentation/pages/home_page.dart';
import '../../../fixed_expenses/presentation/cubit/fixed_expense_cubit.dart';
import '../../../profile/presentation/cubit/user_profile_cubit.dart';
import '../../../profile/presentation/pages/profile_setup_page.dart';
import '../cubit/auth_cubit.dart';
import 'register_page.dart';

class AuthGatePage extends StatelessWidget {
  const AuthGatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.loading || state.status == AuthStatus.initial) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state.isAuthenticated) {
          final userId = FirebaseAuth.instance.currentUser?.uid;
          if (userId == null) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          return BlocProvider(
            create: (_) => getIt<UserProfileCubit>()..loadProfile(userId),
            child: const _AuthenticatedContent(),
          );
        }
        return RegisterPage(initialMode: state.entryMode);
      },
    );
  }
}

class _AuthenticatedContent extends StatelessWidget {
  const _AuthenticatedContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileCubit, UserProfileState>(
      builder: (context, state) {
        if (state.status == UserProfileStatus.loading ||
            state.status == UserProfileStatus.initial) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state.status == UserProfileStatus.error) {
          return Scaffold(
            body: Center(child: Text(state.errorMessage ?? 'Failed to load profile')),
          );
        }

        if (state.requiresSetup || state.profile == null) {
          return const ProfileSetupPage();
        }

        final profileCubit = context.read<UserProfileCubit>();
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: profileCubit),
            BlocProvider(create: (_) => getIt<ExpenseCubit>()..loadExpenses()),
            BlocProvider(create: (_) => getIt<AddExpenseCubit>()),
            BlocProvider(
              create: (_) => getIt<DashboardCubit>()..loadDashboard(),
            ),
            BlocProvider(
              create: (_) => getIt<FixedExpenseCubit>()..loadFixedExpenses(),
            ),
            BlocProvider(create: (_) => getIt<SyncCubit>()),
          ],
          child: const HomePage(),
        );
      },
    );
  }
}
