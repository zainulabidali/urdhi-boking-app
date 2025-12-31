import 'package:hive/hive.dart';

part 'booking.g.dart';

/// Default prayers for the app
const List<String> defaultPrayers = ['Dhuhr', 'Asr', 'Isha'];

@HiveType(typeId: 1)
class Booking extends HiveObject {
  @HiveField(0)
  String mosqueName;

  @HiveField(1)
  String location;

  @HiveField(2)
  String mobileNumber;

  @HiveField(3)
  String description;

  @HiveField(4)
  DateTime date;

  @HiveField(5)
  String prayerName; // Now supports custom prayers

  Booking({
    required this.mosqueName,
    required this.location,
    required this.mobileNumber,
    required this.description,
    required this.date,
    required this.prayerName,
  });

  // Unique key for the booking (date + prayerName)
  static String generateKey(DateTime date, String prayerName) {
    return "${date.year}-${date.month}-${date.day}_$prayerName";
  }
}
