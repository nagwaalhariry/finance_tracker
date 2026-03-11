import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/auth_gate_page.dart';
import 'injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await configureDependencies();
  runApp(const FinanceTrackerApp());
}

class FinanceTrackerApp extends StatelessWidget {
  const FinanceTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthCubit>()),
      ],
      child: MaterialApp(
        title: 'Finance Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.green,
        ),
        home: const AuthGatePage(),
      ),
    );
  }
}
