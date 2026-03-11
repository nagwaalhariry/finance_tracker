import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection.dart';
import '../../../expenses/presentation/cubit/add_expense_cubit.dart';
import '../../../expenses/presentation/cubit/dashboard_cubit.dart';
import '../../../expenses/presentation/cubit/expense_cubit.dart';
import '../../../expenses/presentation/cubit/sync_cubit.dart';
import '../../../expenses/presentation/pages/home_page.dart';
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
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<ExpenseCubit>()..loadExpenses()),
              BlocProvider(create: (_) => getIt<AddExpenseCubit>()),
              BlocProvider(
                create: (_) => getIt<DashboardCubit>()..loadDashboard(),
              ),
              BlocProvider(create: (_) => getIt<SyncCubit>()),
            ],
            child: const HomePage(),
          );
        }
        return RegisterPage(initialMode: state.entryMode);
      },
    );
  }
}
