import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/isar_service.dart';
import '../../domain/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository, this._isarService)
      : super(const AuthState.initial()) {
    checkAuth();
  }

  final AuthRepository _authRepository;
  final IsarService _isarService;

  Future<void> checkAuth() async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    final loggedIn = _authRepository.isLoggedIn();
    if (loggedIn) {
      final uid = _authRepository.currentUserId();
      if (uid != null) {
        await _isarService.openForUser(uid);
      }
    }
    emit(
      state.copyWith(
        status: AuthStatus.success,
        isAuthenticated: loggedIn,
      ),
    );
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      await _authRepository.registerWithEmail(email: email, password: password);
      final uid = _authRepository.currentUserId();
      if (uid != null) {
        await _isarService.openForUser(uid);
      }
      emit(
        state.copyWith(
          status: AuthStatus.success,
          isAuthenticated: true,
          entryMode: AuthEntryMode.register,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          isAuthenticated: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      await _authRepository.loginWithEmail(email: email, password: password);
      final uid = _authRepository.currentUserId();
      if (uid != null) {
        await _isarService.openForUser(uid);
      }
      emit(
        state.copyWith(
          status: AuthStatus.success,
          isAuthenticated: true,
          entryMode: AuthEntryMode.login,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          isAuthenticated: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> signOut() async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    await _authRepository.signOut();
    await _isarService.closeCurrent();
    emit(
      state.copyWith(
        status: AuthStatus.success,
        isAuthenticated: false,
        entryMode: AuthEntryMode.login,
      ),
    );
  }

  Future<void> deleteAccount() async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      await _authRepository.deleteAccount();
      await _isarService.closeCurrent();
      emit(
        state.copyWith(
          status: AuthStatus.success,
          isAuthenticated: false,
          entryMode: AuthEntryMode.register,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          isAuthenticated: true,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
