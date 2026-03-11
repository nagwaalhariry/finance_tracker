part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, success, error }
enum AuthEntryMode { login, register }

class AuthState extends Equatable {
  const AuthState({
    required this.status,
    required this.isAuthenticated,
    required this.entryMode,
    this.errorMessage,
  });

  const AuthState.initial()
      : status = AuthStatus.initial,
        isAuthenticated = false,
        entryMode = AuthEntryMode.register,
        errorMessage = null;

  final AuthStatus status;
  final bool isAuthenticated;
  final AuthEntryMode entryMode;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    bool? isAuthenticated,
    AuthEntryMode? entryMode,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      entryMode: entryMode ?? this.entryMode,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, isAuthenticated, entryMode, errorMessage];
}
