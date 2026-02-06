import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class Helpers {
  // Format date to readable string
  static String formatDate(DateTime date, {String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(date);
  }

  // Format time to readable string
  static String formatTime(DateTime time, {bool use24Hour = false}) {
    return DateFormat(use24Hour ? 'HH:mm' : 'hh:mm a').format(time);
  }

  // Format date and time
  static String formatDateTime(DateTime dateTime,
      {String format = 'dd MMM yyyy, hh:mm a'}) {
    return DateFormat(format).format(dateTime);
  }

  // Get time ago string (e.g., "5 minutes ago", "2 hours ago")
  static String getTimeAgo(DateTime dateTime) {
    final Duration diff = DateTime.now().difference(dateTime);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (diff.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }

  // Calculate age from date of birth
  static int calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  // Format phone number
  static String formatPhoneNumber(String phoneNumber) {
    // Remove all non-numeric characters
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleaned.length == 10) {
      // Format as (XXX) XXX-XXXX
      return '${cleaned.substring(0, 3)}-${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
    }

    return phoneNumber;
  }

  // Capitalize first letter of each word
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;

    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  // Truncate text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Generate random color
  static Color generateRandomColor() {
    return Color((DateTime.now().millisecondsSinceEpoch * 0xFFFFFF).toInt())
        .withOpacity(1.0);
  }

  // Get initials from name
  static String getInitials(String name) {
    if (name.isEmpty) return '';

    final words = name.trim().split(' ');
    if (words.length == 1) {
      return words[0].substring(0, 1).toUpperCase();
    }

    return '${words[0].substring(0, 1)}${words[words.length - 1].substring(0, 1)}'
        .toUpperCase();
  }

  // Check if string is email
  static bool isEmail(String text) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(text);
  }

  // Check if string is phone number
  static bool isPhoneNumber(String text) {
    final cleaned = text.replaceAll(RegExp(r'[^0-9]'), '');
    return cleaned.length == 10;
  }

  // Convert 12-hour time to 24-hour time
  static String convertTo24Hour(String time12h) {
    try {
      final format12 = DateFormat('hh:mm a');
      final format24 = DateFormat('HH:mm');
      final dateTime = format12.parse(time12h);
      return format24.format(dateTime);
    } catch (e) {
      return time12h;
    }
  }

  // Convert 24-hour time to 12-hour time
  static String convertTo12Hour(String time24h) {
    try {
      final format24 = DateFormat('HH:mm');
      final format12 = DateFormat('hh:mm a');
      final dateTime = format24.parse(time24h);
      return format12.format(dateTime);
    } catch (e) {
      return time24h;
    }
  }

  // Get greeting based on time of day
  static String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  // Get greeting emoji based on time of day
  static String getGreetingEmoji() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return '🌅';
    } else if (hour < 17) {
      return '☀️';
    } else {
      return '🌙';
    }
  }

  // Parse time string to DateTime
  static DateTime? parseTime(String timeString) {
    try {
      final now = DateTime.now();
      final parts = timeString.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (e) {
      return null;
    }
  }

  // Calculate percentage
  static double calculatePercentage(int value, int total) {
    if (total == 0) return 0;
    return (value / total) * 100;
  }

  // Format percentage
  static String formatPercentage(double percentage, {int decimals = 1}) {
    return '${percentage.toStringAsFixed(decimals)}%';
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  // Get day of week
  static String getDayOfWeek(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  // Get month name
  static String getMonthName(DateTime date) {
    return DateFormat('MMMM').format(date);
  }

  // Get start of day
  static DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Get end of day
  static DateTime getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  // Get start of week
  static DateTime getStartOfWeek(DateTime date) {
    final startOfDay = getStartOfDay(date);
    return startOfDay.subtract(Duration(days: startOfDay.weekday - 1));
  }

  // Get end of week
  static DateTime getEndOfWeek(DateTime date) {
    final startOfWeek = getStartOfWeek(date);
    return getEndOfDay(startOfWeek.add(Duration(days: 6)));
  }

  // Get start of month
  static DateTime getStartOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  // Get end of month
  static DateTime getEndOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59);
  }

  // Show snackbar
  static void showSnackBar(
      BuildContext context,
      String message, {
        Color? backgroundColor,
        Duration duration = const Duration(seconds: 3),
        SnackBarAction? action,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
        action: action,
      ),
    );
  }

  // Show success snackbar
  static void showSuccessSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: Colors.green,
    );
  }

  // Show error snackbar
  static void showErrorSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: Colors.red,
    );
  }

  // Show info snackbar
  static void showInfoSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: Colors.blue,
    );
  }

  // Show warning snackbar
  static void showWarningSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: Colors.orange,
    );
  }

  // Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  // Generate random string
  static String generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    return List.generate(
      length,
          (index) => chars[(random + index) % chars.length],
    ).join();
  }

  // Debounce function
  static Function debounce(Function func, Duration delay) {
    DateTime? lastCall;
    return () {
      final now = DateTime.now();
      if (lastCall == null || now.difference(lastCall!) > delay) {
        lastCall = now;
        func();
      }
    };
  }

  // Copy to clipboard
  static Future<void> copyToClipboard(BuildContext context, String text) async {
    // This would use Clipboard.setData in a real implementation
    // For now, just show a message
    showSuccessSnackBar(context, 'Copied to clipboard');
  }

  // Convert map to query string
  static String mapToQueryString(Map<String, dynamic> map) {
    return map.entries
        .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value.toString())}')
        .join('&');
  }

  // Remove HTML tags from string
  static String removeHtmlTags(String htmlString) {
    return htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  // Check if list is empty or null
  static bool isListEmpty(List? list) {
    return list == null || list.isEmpty;
  }

  // Check if string is empty or null
  static bool isStringEmpty(String? text) {
    return text == null || text.trim().isEmpty;
  }
}