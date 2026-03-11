import '../entities/user_profile_entity.dart';
import '../repositories/user_profile_repository.dart';

class SaveUserProfileUseCase {
  SaveUserProfileUseCase(this._repository);

  final UserProfileRepository _repository;

  Future<void> call(UserProfileEntity profile) => _repository.saveProfile(profile);
}
