import 'package:isar/isar.dart';

import '../../domain/entities/expense_entity.dart';

part 'expense_model.g.dart';

@collection
class ExpenseModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  late String title;
  late double amount;
  late String category;
  late DateTime date;
  String? note;
  late bool isSynced;
  late DateTime createdAt;

  ExpenseEntity toEntity() => ExpenseEntity(
        id: id,
        title: title,
        amount: amount,
        category: category,
        date: date,
        note: note,
        isSynced: isSynced,
        createdAt: createdAt,
      );

  static ExpenseModel fromEntity(ExpenseEntity entity) {
    return ExpenseModel()
      ..id = entity.id
      ..title = entity.title
      ..amount = entity.amount
      ..category = entity.category
      ..date = entity.date
      ..note = entity.note
      ..isSynced = entity.isSynced
      ..createdAt = entity.createdAt;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'amount': amount,
        'category': category,
        'date': date.toIso8601String(),
        'note': note,
        'createdAt': createdAt.toIso8601String(),
      };
}
