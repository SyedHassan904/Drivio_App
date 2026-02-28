import 'package:intl/intl.dart';

String formatDateTime(DateTime datetime) {
  final local = datetime.toLocal();
  return DateFormat('dd MMM yyyy • hh:mm a').format(local);
}
