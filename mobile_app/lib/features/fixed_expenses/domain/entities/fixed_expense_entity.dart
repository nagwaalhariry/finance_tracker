import 'package:equatable/equatable.dart';

class FixedExpenseEntity extends Equatable {
  const FixedExpenseEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.createdAt,
  });

  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime createdAt;

  FixedExpenseEntity copyWith({
    String? title,
    double? amount,
    String? category,
  }) {
    return FixedExpenseEntity(
      id: id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, title, amount, category, createdAt];
}

