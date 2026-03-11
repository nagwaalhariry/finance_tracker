import '../entities/user_profile_entity.dart';
import '../repositories/user_profile_repository.dart';

class GetUserProfileUseCase {
  GetUserProfileUseCase(this._repository);

  final UserProfileRepository _repository;

  Future<UserProfileEntity?> call(String userId) => _repository.getProfile(userId);
}
