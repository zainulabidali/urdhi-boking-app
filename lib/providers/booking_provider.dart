import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/booking.dart';

class BookingProvider with ChangeNotifier {
  static const String boxName = 'bookings_box';
  late Box<Booking> _box;
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  Future<void> init() async {
    _box = await Hive.openBox<Booking>(boxName);
    notifyListeners();
  }

  // Get booking for a specific date and prayer
  Booking? getBooking(DateTime date, PrayerType type) {
    final key = Booking.generateKey(date, type);
    return _box.get(key);
  }

  // Check if a date has any bookings
  bool hasBookingsOnDate(DateTime date) {
    return PrayerType.values.any((type) => getBooking(date, type) != null);
  }

  // Get count of bookings for a specific date
  int getBookingCount(DateTime date) {
    int count = 0;
    for (final type in PrayerType.values) {
      if (getBooking(date, type) != null) {
        count++;
      }
    }
    return count;
  }

  // Add or update booking
  Future<void> saveBooking(Booking booking) async {
    final key = Booking.generateKey(booking.date, booking.prayerType);
    await _box.put(key, booking);
    notifyListeners();
  }

  // Delete booking
  Future<void> clearBooking(DateTime date, PrayerType type) async {
    final key = Booking.generateKey(date, type);
    await _box.delete(key);
    notifyListeners();
  }
}
