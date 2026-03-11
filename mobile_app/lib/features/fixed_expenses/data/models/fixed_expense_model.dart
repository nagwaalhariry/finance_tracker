import 'package:isar/isar.dart';

import '../../domain/entities/fixed_expense_entity.dart';

part 'fixed_expense_model.g.dart';

@collection
class FixedExpenseModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;
  late String title;
  late double amount;
  late String category;
  late DateTime createdAt;

  FixedExpenseEntity toEntity() => FixedExpenseEntity(
        id: id,
        title: title,
        amount: amount,
        category: category,
        createdAt: createdAt,
      );

  static FixedExpenseModel fromEntity(FixedExpenseEntity entity) {
    return FixedExpenseModel()
      ..id = entity.id
      ..title = entity.title
      ..amount = entity.amount
      ..category = entity.category
      ..createdAt = entity.createdAt;
  }
}

