import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../datasources/user_profile_local_datasource.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  UserProfileRepositoryImpl(this._localDataSource);

  final UserProfileLocalDataSource _localDataSource;

  @override
  Future<UserProfileEntity?> getProfile(String userId) {
    return _localDataSource.getProfile(userId);
  }

  @override
  Future<void> saveProfile(UserProfileEntity profile) {
    return _localDataSource.saveProfile(profile);
  }
}
