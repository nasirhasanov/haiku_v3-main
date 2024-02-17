import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

extension TimestampExtensions on Timestamp {
  String get customTimeAgo {
    final date = toDate();
    final difference = DateTime.now().difference(date);
    if (difference.inDays >= 7) {
      return DateFormat('MMM d, yyyy').format(date);
    }
    return timeago.format(date);
  }
}
