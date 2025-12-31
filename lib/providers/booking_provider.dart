import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/booking.dart';

class BookingProvider with ChangeNotifier {
  static const String boxName = 'bookings_box';
  late Box<Booking> _box;
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
    // CRITICAL: Delete box BEFORE opening to prevent typeId errors from old data
    // This ensures we never try to read corrupted/incompatible data
    if (await Hive.boxExists(boxName)) {
      await Hive.deleteBoxFromDisk(boxName);
    }
    _box = await Hive.openBox<Booking>(boxName);
    // Optionally, load custom prayers from persistent storage if needed
    notifyListeners();
  }

  // Add a custom prayer/item
  void addCustomPrayer(String name) {
    if (!_customPrayers.contains(name) && !defaultPrayers.contains(name)) {
      _customPrayers.add(name);
      notifyListeners();
      // Optionally, persist custom prayers
    }
  }

  // Remove a custom prayer/item
  void removeCustomPrayer(String name) {
    _customPrayers.remove(name);
    notifyListeners();
    // Optionally, persist custom prayers
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
}
