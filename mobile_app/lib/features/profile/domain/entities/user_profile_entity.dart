import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  const UserProfileEntity({
    required this.userId,
    required this.monthlySalary,
    required this.currency,
  });

  final String userId;
  final double monthlySalary;
  final String currency;

  UserProfileEntity copyWith({
    double? monthlySalary,
    String? currency,
  }) {
    return UserProfileEntity(
      userId: userId,
      monthlySalary: monthlySalary ?? this.monthlySalary,
      currency: currency ?? this.currency,
    );
  }

  @override
  List<Object?> get props => [userId, monthlySalary, currency];
}
