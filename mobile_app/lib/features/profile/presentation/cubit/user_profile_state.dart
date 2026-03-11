part of 'user_profile_cubit.dart';

enum UserProfileStatus { initial, loading, loaded, error }

const _noProfileChange = Object();
const _noErrorMessageChange = Object();

class UserProfileState extends Equatable {
  const UserProfileState({
    required this.status,
    required this.requiresSetup,
    this.profile,
    this.errorMessage,
  });

  const UserProfileState.initial()
      : status = UserProfileStatus.initial,
        requiresSetup = false,
        profile = null,
        errorMessage = null;

  final UserProfileStatus status;
  final bool requiresSetup;
  final UserProfileEntity? profile;
  final String? errorMessage;

  UserProfileState copyWith({
    UserProfileStatus? status,
    bool? requiresSetup,
    Object? profile = _noProfileChange,
    Object? errorMessage = _noErrorMessageChange,
  }) {
    return UserProfileState(
      status: status ?? this.status,
      requiresSetup: requiresSetup ?? this.requiresSetup,
      profile: identical(profile, _noProfileChange)
          ? this.profile
          : profile as UserProfileEntity?,
      errorMessage: identical(errorMessage, _noErrorMessageChange)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, requiresSetup, profile, errorMessage];
}
