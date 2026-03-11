import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user_profile_entity.dart';

abstract class UserProfileLocalDataSource {
  Future<UserProfileEntity?> getProfile(String userId);
  Future<void> saveProfile(UserProfileEntity profile);
}

class UserProfileLocalDataSourceImpl implements UserProfileLocalDataSource {
  static String _salaryKey(String userId) => 'profile_${userId}_salary';
  static String _currencyKey(String userId) => 'profile_${userId}_currency';

  @override
  Future<UserProfileEntity?> getProfile(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final salary = prefs.getDouble(_salaryKey(userId));
    final currency = prefs.getString(_currencyKey(userId));
    if (salary == null || currency == null) return null;

    return UserProfileEntity(
      userId: userId,
      monthlySalary: salary,
      currency: currency,
    );
  }

  @override
  Future<void> saveProfile(UserProfileEntity profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_salaryKey(profile.userId), profile.monthlySalary);
    await prefs.setString(_currencyKey(profile.userId), profile.currency);
  }
}
