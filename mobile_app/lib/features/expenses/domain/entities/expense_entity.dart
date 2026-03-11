import 'package:equatable/equatable.dart';

class ExpenseEntity extends Equatable {
  const ExpenseEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
    required this.isSynced,
    required this.createdAt,
  });

  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String? note;
  final bool isSynced;
  final DateTime createdAt;

  ExpenseEntity copyWith({
    String? title,
    double? amount,
    String? category,
    DateTime? date,
    String? note,
    bool? isSynced,
  }) {
    return ExpenseEntity(
      id: id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        amount,
        category,
        date,
        note,
        isSynced,
        createdAt,
      ];
}
