import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_profile_entity.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/save_user_profile_usecase.dart';

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit(this._getUserProfile, this._saveUserProfile)
      : super(const UserProfileState.initial());

  final GetUserProfileUseCase _getUserProfile;
  final SaveUserProfileUseCase _saveUserProfile;

  Future<void> loadProfile(String userId) async {
    emit(state.copyWith(status: UserProfileStatus.loading));
    try {
      final profile = await _getUserProfile(userId);
      emit(
        state.copyWith(
          status: UserProfileStatus.loaded,
          profile: profile,
          requiresSetup: profile == null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: UserProfileStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> saveProfile({
    required String userId,
    required double monthlySalary,
    required String currency,
  }) async {
    emit(state.copyWith(status: UserProfileStatus.loading));
    try {
      final profile = UserProfileEntity(
        userId: userId,
        monthlySalary: monthlySalary,
        currency: currency,
      );
      await _saveUserProfile(profile);
      emit(
        state.copyWith(
          status: UserProfileStatus.loaded,
          profile: profile,
          requiresSetup: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: UserProfileStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
