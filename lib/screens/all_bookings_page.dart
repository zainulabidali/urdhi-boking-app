import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/booking_provider.dart';

class AllBookingsPage extends StatelessWidget {
  const AllBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/img2.jpg', fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: Container(color: Colors.black.withOpacity(0.3)),
        ),
        Consumer<BookingProvider>(
          builder: (context, provider, child) {
            final now = DateTime.now();
            final startDate = DateTime.utc(now.year, now.month, now.day);
            final endDate = startDate.add(const Duration(days: 30));
            final dayCount = endDate.difference(startDate).inDays;

            return ListView.builder(
padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
              itemCount: dayCount + 1,
              itemBuilder: (context, index) {
                final date = startDate.add(Duration(days: index));
                return _DateCard(date: date, provider: provider);
              },
            );
          },
        ),
      ],
    );
  }
}

class _DateCard extends StatelessWidget {
  final DateTime date;
  final BookingProvider provider;

  const _DateCard({required this.date, required this.provider});

  @override
  Widget build(BuildContext context) {
    final allPrayers = provider.allPrayers;
    int totalPrayers = allPrayers.length;
    // ignore: unused_local_variable
    int bookedCount = 0;
    int completedCount = 0;

    for (var prayerName in allPrayers) {
      final booking = provider.getBooking(date, prayerName);
      if (booking != null) {
        bookedCount++;
        if (booking.isCompleted) {
          completedCount++;
        }
      }
    }

    Color tintColor;
    if (completedCount == totalPrayers && totalPrayers > 0) {
      tintColor = const Color(0xFFE8F5E9); // Light Green
    } else if (completedCount == 2) {
      tintColor = const Color.fromARGB(255, 231, 247, 255); // Light Blue
    } else if (completedCount == 1) {
      tintColor = const Color(0xFFFFFDE7); // Light Yellow
    } else {
      tintColor = Colors.white;
    }

   return Container(
  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  padding: const EdgeInsets.all(14),
  decoration: BoxDecoration(
    color: tintColor.withOpacity(0.18),
    borderRadius: BorderRadius.circular(14),
    border: Border.all(
      color: Colors.white.withOpacity(0.08),
    ),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      /// DATE
      Text(
        DateFormat('EEEE, d MMM yyyy').format(date),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Colors.white,
        ),
      ),

      const SizedBox(height: 10),

      /// PRAYER LIST
      ...allPrayers.map((prayerName) {
        final booking = provider.getBooking(date, prayerName);
        final isBooked = booking != null;
        final isCompleted = booking?.isCompleted ?? false;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  prayerName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        isBooked ? FontWeight.w500 : FontWeight.normal,
                    color: isBooked
                        ? Colors.white
                        : Colors.white38,
                    decoration: isBooked
                        ? null
                        : TextDecoration.lineThrough,
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  if (isBooked) {
                    provider.toggleCompletion(booking);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Prayer not booked yet.',
                        ),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(6),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Colors.green
                        : isBooked
                            ? Colors.white24
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isBooked
                          ? Colors.transparent
                          : Colors.white24,
                    ),
                  ),
                  child: isBooked
                      ? const Icon(Icons.check,
                          color: Colors.white, size: 16)
                      : null,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ],
  ),
);

  }
}
