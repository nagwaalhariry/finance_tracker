import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  static String monthKey(DateTime date) => DateFormat('yyyy-MM').format(date);
}
