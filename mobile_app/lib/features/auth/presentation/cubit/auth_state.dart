part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, success, error }
enum AuthEntryMode { login, register }

class AuthState extends Equatable {
  const AuthState({
    required this.status,
    required this.isAuthenticated,
    required this.entryMode,
    required this.requireBalanceSetup,
    this.errorMessage,
  });

  const AuthState.initial()
      : status = AuthStatus.initial,
        isAuthenticated = false,
        entryMode = AuthEntryMode.register,
        requireBalanceSetup = false,
        errorMessage = null;

  final AuthStatus status;
  final bool isAuthenticated;
  final AuthEntryMode entryMode;
  final bool requireBalanceSetup;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    bool? isAuthenticated,
    AuthEntryMode? entryMode,
    bool? requireBalanceSetup,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      entryMode: entryMode ?? this.entryMode,
      requireBalanceSetup: requireBalanceSetup ?? this.requireBalanceSetup,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, isAuthenticated, entryMode, requireBalanceSetup, errorMessage];
}
