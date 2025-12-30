import 'package:hive/hive.dart';

part 'booking.g.dart';

@HiveType(typeId: 0)
enum PrayerType {
  @HiveField(0)
  dhuhr,
  @HiveField(1)
  asr,
  @HiveField(2)
  isha,
}

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
  PrayerType prayerType;

  Booking({
    required this.mosqueName,
    required this.location,
    required this.mobileNumber,
    required this.description,
    required this.date,
    required this.prayerType,
  });

  // Unique key for the booking (date + prayerType)
  static String generateKey(DateTime date, PrayerType prayerType) {
    return "${date.year}-${date.month}-${date.day}_${prayerType.name}";
  }
}
