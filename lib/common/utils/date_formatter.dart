import 'package:intl/intl.dart';

String formatDateRange(DateTime startTime, DateTime endTime) {
  // Định dạng ngày (ví dụ: "Jan 1")
  final monthDayFormat = DateFormat('MMM d');
  // Định dạng năm (ví dụ: "2025")
  final yearFormat = DateFormat('y');

  // Lấy chuỗi ngày bắt đầu và kết thúc
  String start = monthDayFormat.format(startTime);
  String end = monthDayFormat.format(endTime);

  // Nếu hai ngày cùng năm, chỉ hiển thị năm một lần
  if (startTime.year == endTime.year) {
    return '$start to $end, ${yearFormat.format(startTime)}';
  } else {
    // Nếu khác năm, hiển thị đầy đủ cả năm
    return '$start, ${yearFormat.format(startTime)} to $end, ${yearFormat.format(endTime)}';
  }
}
