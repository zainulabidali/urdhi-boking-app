import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/booking.dart';
import '../services/hive_service.dart';

class BookingProvider with ChangeNotifier {
  late Box<Booking> _box;
  late Box _settingsBox;
  DateTime _selectedDate = DateTime.now();

  // List of custom prayers/items added by the user
  List<String> _customPrayers = [];

  DateTime get selectedDate => _selectedDate;
  List<String> get customPrayers => _customPrayers;

  List<String> get allPrayers => [...defaultPrayers, ..._customPrayers];

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  Future<void> init() async {
    // Use the Hive service for proper initialization
    _box = await HiveService.openBookingsBox();
    _settingsBox = await HiveService.openSettingsBox();

    // Load custom prayers from disk
    _customPrayers = List<String>.from(
      _settingsBox.get(HiveService.customPrayersKey, defaultValue: []),
    );

    notifyListeners();
  }

  // Add a custom prayer/item
  Future<void> addCustomPrayer(String name) async {
    if (!_customPrayers.contains(name) && !defaultPrayers.contains(name)) {
      _customPrayers.add(name);
      await _settingsBox.put(HiveService.customPrayersKey, _customPrayers);
      notifyListeners();
    }
  }

  // Remove a custom prayer/item
  Future<void> removeCustomPrayer(String name) async {
    if (_customPrayers.contains(name)) {
      _customPrayers.remove(name);
      await _settingsBox.put(HiveService.customPrayersKey, _customPrayers);
      notifyListeners();
    }
  }

  // Get booking for a specific date and prayer name
  Booking? getBooking(DateTime date, String prayerName) {
    final key = Booking.generateKey(date, prayerName);
    return _box.get(key);
  }

  // Check if a date has any bookings
  bool hasBookingsOnDate(DateTime date) {
    return allPrayers.any((name) => getBooking(date, name) != null);
  }

  // Get count of bookings for a specific date
  int getBookingCount(DateTime date) {
    int count = 0;
    for (final name in allPrayers) {
      if (getBooking(date, name) != null) {
        count++;
      }
    }
    return count;
  }

  // Add or update booking
  Future<void> saveBooking(Booking booking) async {
    final key = Booking.generateKey(booking.date, booking.prayerName);
    await _box.put(key, booking);
    notifyListeners();
  }

  // Delete booking
  Future<void> clearBooking(DateTime date, String prayerName) async {
    final key = Booking.generateKey(date, prayerName);
    await _box.delete(key);
    notifyListeners();
  }

  // Toggle completion status of a booking
  Future<void> toggleCompletion(Booking booking) async {
    booking.isCompleted = !booking.isCompleted;
    await booking.save(); // Efficiently saves the changes to Hive
    notifyListeners();
  }
}
