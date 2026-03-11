import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/expenses/data/models/expense_model.dart';
import '../../features/fixed_expenses/data/models/fixed_expense_model.dart';

class IsarService {
  Isar? _db;
  String? _activeUserId;

  Isar get db {
    final db = _db;
    if (db == null || !db.isOpen) {
      throw StateError('Isar is not initialized for an authenticated user.');
    }
    return db;
  }

  Future<void> openForUser(String userId) async {
    if (_activeUserId == userId && _db?.isOpen == true) return;

    if (_db?.isOpen == true) {
      await _db!.close();
    }

    final dir = await getApplicationDocumentsDirectory();
    try {
      _db = await Isar.open(
        [ExpenseModelSchema, FixedExpenseModelSchema],
        directory: dir.path,
        name: 'finance_tracker_$userId',
        inspector: true,
      );
      _activeUserId = userId;
    } on IsarError {
      // Fallback to expense-only DB if fixed-expense generated schema is stale/invalid.
      // Run build_runner locally to regenerate fixed_expense_model.g.dart and remove fallback usage.
      _db = await Isar.open(
        [ExpenseModelSchema],
        directory: dir.path,
        name: 'finance_tracker_$userId',
        inspector: true,
      );
      _activeUserId = userId;
    }
  }

  Future<void> closeCurrent() async {
    if (_db?.isOpen == true) {
      await _db!.close();
    }
    _db = null;
    _activeUserId = null;
  }
}
