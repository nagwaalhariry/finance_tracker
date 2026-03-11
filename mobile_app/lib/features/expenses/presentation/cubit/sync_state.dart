part of 'sync_cubit.dart';

enum SyncStatus { initial, loading, success, error }

class SyncState extends Equatable {
  const SyncState({
    required this.status,
    required this.syncedCount,
    this.errorMessage,
  });

  const SyncState.initial()
      : status = SyncStatus.initial,
        syncedCount = 0,
        errorMessage = null;

  final SyncStatus status;
  final int syncedCount;
  final String? errorMessage;

  SyncState copyWith({
    SyncStatus? status,
    int? syncedCount,
    String? errorMessage,
  }) {
    return SyncState(
      status: status ?? this.status,
      syncedCount: syncedCount ?? this.syncedCount,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, syncedCount, errorMessage];
}
