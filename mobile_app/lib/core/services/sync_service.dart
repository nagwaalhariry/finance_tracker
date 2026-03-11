import 'package:firebase_auth/firebase_auth.dart';
import 'package:workmanager/workmanager.dart';

import '../../features/expenses/data/datasources/local_expense_datasource.dart';
import '../../features/expenses/data/datasources/remote_expense_datasource.dart';
import '../../features/expenses/data/repositories/expense_repository_impl.dart';
import '../../features/expenses/domain/usecases/sync_expenses_usecase.dart';
import '../constants/app_constants.dart';
import '../network/dio_client.dart';
import 'isar_service.dart';

class SyncService {
  SyncService(this._syncExpensesUseCase);

  final SyncExpensesUseCase _syncExpensesUseCase;

  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      try {
        if (task == AppConstants.syncTaskName) {
          final uid = FirebaseAuth.instance.currentUser?.uid;
          if (uid == null) return Future.value(true);

          final isarService = IsarService();
          await isarService.openForUser(uid);

          final repo = ExpenseRepositoryImpl(
            LocalExpenseDataSourceImpl(isarService),
            RemoteExpenseDataSourceImpl(DioClient.create()),
          );
          await SyncExpensesUseCase(repo)();
        }
        return Future.value(true);
      } catch (_) {
        return Future.value(false);
      }
    });
  }

  Future<void> initializeBackgroundSync() async {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
    await Workmanager().registerPeriodicTask(
      'expense-sync-id',
      AppConstants.syncTaskName,
      frequency: const Duration(minutes: 10),
      existingWorkPolicy: ExistingWorkPolicy.keep,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  Future<int> syncNow() async {
    return _syncExpensesUseCase();
  }
}
