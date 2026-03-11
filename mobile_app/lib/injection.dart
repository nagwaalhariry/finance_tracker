import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'core/network/dio_client.dart';
import 'core/services/isar_service.dart';
import 'core/services/sync_service.dart';
import 'features/auth/data/firebase_auth_repository.dart';
import 'features/auth/domain/auth_repository.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/expenses/data/datasources/local_expense_datasource.dart';
import 'features/expenses/data/datasources/remote_expense_datasource.dart';
import 'features/expenses/data/repositories/expense_repository_impl.dart';
import 'features/expenses/domain/repositories/expense_repository.dart';
import 'features/expenses/domain/usecases/add_expense_usecase.dart';
import 'features/expenses/domain/usecases/delete_expense_usecase.dart';
import 'features/expenses/domain/usecases/get_all_expenses_usecase.dart';
import 'features/expenses/domain/usecases/sync_expenses_usecase.dart';
import 'features/expenses/domain/usecases/update_expense_usecase.dart';
import 'features/expenses/presentation/cubit/add_expense_cubit.dart';
import 'features/expenses/presentation/cubit/dashboard_cubit.dart';
import 'features/expenses/presentation/cubit/expense_cubit.dart';
import 'features/expenses/presentation/cubit/sync_cubit.dart';

final getIt = GetIt.instance;

@InjectableInit(initializerName: r'$initGetIt')
Future<void> configureDependencies() async {
  final isarService = IsarService();

  getIt
    ..registerSingleton<IsarService>(isarService)
    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    ..registerLazySingleton<AuthRepository>(
      () => FirebaseAuthRepository(getIt<FirebaseAuth>()),
    )
    ..registerLazySingleton<Dio>(() => DioClient.create())
    ..registerLazySingleton<LocalExpenseDataSource>(
      () => LocalExpenseDataSourceImpl(getIt<IsarService>()),
    )
    ..registerLazySingleton<RemoteExpenseDataSource>(
      () => RemoteExpenseDataSourceImpl(getIt<Dio>()),
    )
    ..registerLazySingleton<ExpenseRepository>(
      () => ExpenseRepositoryImpl(
        getIt<LocalExpenseDataSource>(),
        getIt<RemoteExpenseDataSource>(),
      ),
    )
    ..registerLazySingleton(() => AddExpenseUseCase(getIt<ExpenseRepository>()))
    ..registerLazySingleton(
        () => GetAllExpensesUseCase(getIt<ExpenseRepository>()))
    ..registerLazySingleton(
        () => DeleteExpenseUseCase(getIt<ExpenseRepository>()))
    ..registerLazySingleton(
        () => UpdateExpenseUseCase(getIt<ExpenseRepository>()))
    ..registerLazySingleton(
        () => SyncExpensesUseCase(getIt<ExpenseRepository>()))
    ..registerLazySingleton(() => SyncService(getIt<SyncExpensesUseCase>()))
    ..registerFactory(
      () => ExpenseCubit(
        getIt<GetAllExpensesUseCase>(),
        getIt<DeleteExpenseUseCase>(),
        getIt<UpdateExpenseUseCase>(),
      ),
    )
    ..registerFactory(() => AddExpenseCubit(getIt<AddExpenseUseCase>()))
    ..registerFactory(() => DashboardCubit(getIt<GetAllExpensesUseCase>()))
    ..registerFactory(
      () => AuthCubit(getIt<AuthRepository>(), getIt<IsarService>()),
    )
    ..registerFactory(
      () => SyncCubit(getIt<SyncExpensesUseCase>(), getIt<SyncService>()),
    );
}
