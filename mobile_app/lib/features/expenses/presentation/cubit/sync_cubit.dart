import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/sync_service.dart';
import '../../domain/usecases/sync_expenses_usecase.dart';

part 'sync_state.dart';

class SyncCubit extends Cubit<SyncState> {
  SyncCubit(this._syncExpensesUseCase, this._syncService)
      : super(const SyncState.initial()) {
    _syncService.initializeBackgroundSync();
  }

  final SyncExpensesUseCase _syncExpensesUseCase;
  final SyncService _syncService;

  Future<void> syncNow() async {
    emit(state.copyWith(status: SyncStatus.loading));
    try {
      final syncedCount = await _syncExpensesUseCase();
      emit(state.copyWith(status: SyncStatus.success, syncedCount: syncedCount));
    } catch (e) {
      emit(state.copyWith(status: SyncStatus.error, errorMessage: e.toString()));
    }
  }
}
