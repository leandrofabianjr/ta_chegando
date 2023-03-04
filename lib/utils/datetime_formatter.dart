import 'package:intl/intl.dart';

abstract class DateTimeFormatter {
  static void init() {
    Intl.defaultLocale = 'pt_BR';
    Intl.systemLocale = 'pt_BR';
  }

  static String shortDate(DateTime value) {
    return DateFormat('dd/MM/yy').format(value);
  }

  static String shortDateWithTime(DateTime value) {
    return DateFormat('dd/MM/yy - HH:mm').format(value);
  }

  static String shortDateLongYear(DateTime value) {
    return DateFormat('dd/MM/yyyy').format(value);
  }

  static DateTime? parse(String value) {
    return DateTime.tryParse(value)?.toLocal();
  }
}
