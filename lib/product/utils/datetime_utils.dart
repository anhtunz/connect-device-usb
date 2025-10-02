import 'package:intl/intl.dart';

class DateTimeUtils {
  DateTimeUtils._init();
  static DateTimeUtils? _instance;
  static DateTimeUtils get instance => _instance ??= DateTimeUtils._init();

  String formatDateTimeToString(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd\'T\'00:00:00\'Z\'').format(dateTime);
  }

  String convertCurrentMillisToDateTimeString(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch((time) * 1000);
    return DateFormat('HH:mm:ss dd-MM-yyyy').format(dateTime);
  }
}
