import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/booking.dart';

/// A service class to handle all Hive-related operations
/// This provides a clean separation of concerns for data persistence
class HiveService {
  static const String bookingsBoxName =
      'bookings_v3_box'; // Incrementing version for safety
  static const String settingsBoxName = 'settings_box';
  static const String customPrayersKey = 'custom_prayers';

  /// Initialize Hive with proper setup
  static Future<void> initializeHive() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(100)) {
      Hive.registerAdapter(BookingAdapter());
    }
  }

  /// Get the bookings box instance safely
  static Future<Box<Booking>> openBookingsBox() async {
    try {
      return await Hive.openBox<Booking>(bookingsBoxName);
    } catch (e) {
      // If box is corrupted, we might need a recovery strategy
      debugPrint('Error opening bookings box: $e. Attempting to recover...');
      await Hive.deleteBoxFromDisk(bookingsBoxName);
      return await Hive.openBox<Booking>(bookingsBoxName);
    }
  }

  /// Get the settings box instance safely
  static Future<Box> openSettingsBox() async {
    return await Hive.openBox(settingsBoxName);
  }

  /// Close boxes when done (though typically kept open for app lifetime)
  static Future<void> closeAll() async {
    await Hive.close();
  }
}
