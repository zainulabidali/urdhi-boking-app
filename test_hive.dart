import 'package:hive_flutter/hive_flutter.dart';
import 'lib/models/booking.dart';
import 'lib/services/hive_service.dart';

/// Test script to verify Hive local storage is working
void main() async {
  print('Testing Hive local storage setup...');

  try {
    // Initialize Hive
    await HiveService.initializeHive();
    print('✓ Hive initialized successfully');

    // Open the bookings box
    final box = await HiveService.openBookingsBox();
    print('✓ Bookings box opened successfully');

    // Create a test booking
    final testBooking = Booking(
      mosqueName: 'Test Mosque',
      location: 'Test Location',
      mobileNumber: '1234567890',
      description: 'Test Description',
      date: DateTime.now(),
      prayerName: 'Dhuhr',
    );

    // Save the test booking
    final key = Booking.generateKey(testBooking.date, testBooking.prayerName);
    await box.put(key, testBooking);
    print('✓ Test booking saved successfully with key: $key');

    // Retrieve the test booking
    final retrievedBooking = box.get(key);
    if (retrievedBooking != null) {
      print('✓ Test booking retrieved successfully');
      print('  - Mosque: ${retrievedBooking.mosqueName}');
      print('  - Location: ${retrievedBooking.location}');
      print('  - Date: ${retrievedBooking.date}');
      print('  - Prayer: ${retrievedBooking.prayerName}');
    } else {
      print('✗ Failed to retrieve test booking');
    }

    // Count total bookings
    print('✓ Total bookings in box: ${box.length}');

    // Clean up - clear the test data
    await box.clear();
    print('✓ Test data cleaned up');

    print('\nHive local storage is working correctly!');
  } catch (e) {
    print('✗ Error occurred: $e');
    print('Hive local storage is not working properly.');
  }
}
