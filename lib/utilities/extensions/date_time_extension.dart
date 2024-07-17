import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get descriptionFromNow {
    final now = DateTime.now();
    if (DateUtils.isSameDay(now, this)) {
      return 'Today';
    }

    final yesterday = now.subtract(const Duration(days: 1));
    if (DateUtils.isSameDay(yesterday, this)) {
      return 'Yesterday';
    }

    return DateFormat('MMMM dd, yyyy').format(this);
  }

  String get daysAgo {
    final now = DateTime.now();
    if (DateUtils.isSameDay(now, this)) {
      return 'Today';
    }

    final yesterday = now.subtract(const Duration(days: 1));
    if (DateUtils.isSameDay(yesterday, this)) {
      return 'Yesterday';
    }
    final diff = difference(DateTime.now());
    if (diff.inDays < 30) {
      return '${diff.inDays} days ago';
    }

    final monthDelta = DateUtils.monthDelta(this, DateTime.now());
    return '$monthDelta months ago';
  }
}
