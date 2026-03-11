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
import 'features/fixed_expenses/data/datasources/fixed_expense_local_datasource.dart';
import 'features/fixed_expenses/data/repositories/fixed_expense_repository_impl.dart';
import 'features/fixed_expenses/domain/repositories/fixed_expense_repository.dart';
import 'features/fixed_expenses/domain/usecases/add_fixed_expense_usecase.dart';
import 'features/fixed_expenses/domain/usecases/calculate_total_fixed_expenses_usecase.dart';
import 'features/fixed_expenses/domain/usecases/delete_fixed_expense_usecase.dart';
import 'features/fixed_expenses/domain/usecases/get_fixed_expenses_usecase.dart';
import 'features/fixed_expenses/domain/usecases/update_fixed_expense_usecase.dart';
import 'features/fixed_expenses/presentation/cubit/fixed_expense_cubit.dart';
import 'features/profile/data/datasources/user_profile_local_datasource.dart';
import 'features/profile/data/repositories/user_profile_repository_impl.dart';
import 'features/profile/domain/repositories/user_profile_repository.dart';
import 'features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'features/profile/domain/usecases/save_user_profile_usecase.dart';
import 'features/profile/presentation/cubit/user_profile_cubit.dart';

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
    ..registerLazySingleton<FixedExpenseLocalDataSource>(
      () => FixedExpenseLocalDataSourceImpl(getIt<IsarService>()),
    )
    ..registerLazySingleton<UserProfileLocalDataSource>(
      () => UserProfileLocalDataSourceImpl(),
    )
    ..registerLazySingleton<ExpenseRepository>(
      () => ExpenseRepositoryImpl(
        getIt<LocalExpenseDataSource>(),
        getIt<RemoteExpenseDataSource>(),
      ),
    )
    ..registerLazySingleton<FixedExpenseRepository>(
      () => FixedExpenseRepositoryImpl(getIt<FixedExpenseLocalDataSource>()),
    )
    ..registerLazySingleton<UserProfileRepository>(
      () => UserProfileRepositoryImpl(getIt<UserProfileLocalDataSource>()),
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
    ..registerLazySingleton(
      () => GetFixedExpensesUseCase(getIt<FixedExpenseRepository>()),
    )
    ..registerLazySingleton(
      () => AddFixedExpenseUseCase(getIt<FixedExpenseRepository>()),
    )
    ..registerLazySingleton(
      () => UpdateFixedExpenseUseCase(getIt<FixedExpenseRepository>()),
    )
    ..registerLazySingleton(
      () => DeleteFixedExpenseUseCase(getIt<FixedExpenseRepository>()),
    )
    ..registerLazySingleton(
      () => CalculateTotalFixedExpensesUseCase(getIt<FixedExpenseRepository>()),
    )
    ..registerLazySingleton(
      () => GetUserProfileUseCase(getIt<UserProfileRepository>()),
    )
    ..registerLazySingleton(
      () => SaveUserProfileUseCase(getIt<UserProfileRepository>()),
    )
    ..registerLazySingleton(() => SyncService(getIt<SyncExpensesUseCase>()))
    ..registerFactory(
      () => ExpenseCubit(
        getIt<GetAllExpensesUseCase>(),
        getIt<DeleteExpenseUseCase>(),
        getIt<UpdateExpenseUseCase>(),
      ),
    )
    ..registerFactory(() => AddExpenseCubit(getIt<AddExpenseUseCase>()))
    ..registerFactory(
      () => DashboardCubit(
        getIt<GetAllExpensesUseCase>(),
        getIt<CalculateTotalFixedExpensesUseCase>(),
        getIt<GetUserProfileUseCase>(),
        getIt<AuthRepository>(),
      ),
    )
    ..registerFactory(
      () => FixedExpenseCubit(
        getIt<GetFixedExpensesUseCase>(),
        getIt<AddFixedExpenseUseCase>(),
        getIt<UpdateFixedExpenseUseCase>(),
        getIt<DeleteFixedExpenseUseCase>(),
      ),
    )
    ..registerFactory(
      () => UserProfileCubit(
        getIt<GetUserProfileUseCase>(),
        getIt<SaveUserProfileUseCase>(),
      ),
    )
    ..registerFactory(
      () => AuthCubit(getIt<AuthRepository>(), getIt<IsarService>()),
    )
    ..registerFactory(
      () => SyncCubit(getIt<SyncExpensesUseCase>(), getIt<SyncService>()),
    );
}
