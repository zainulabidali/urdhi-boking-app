import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:urdhi_tracker/widgets/ad_banner.dart';
import '../providers/booking_provider.dart';

class BookingListScreen extends StatelessWidget {
  const BookingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Booking List',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25,color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset('assets/img2.jpg', fit: BoxFit.cover),
          ),
          // Dark Overlay
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          // Content
          Consumer<BookingProvider>(
            builder: (context, provider, child) {
              final now = DateTime.now();
              final startDate = DateTime.utc(now.year, now.month, now.day);
              final endDate = startDate.add(const Duration(days: 30));
              final dayCount = endDate.difference(startDate).inDays;

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(0, 100, 0, 80),
                itemCount: dayCount + 1,
                itemBuilder: (context, index) {
                  final date = startDate.add(Duration(days: index));
                  return _DateCard(date: date, provider: provider);
                },
              );
            },
          ),
        ],
      ),
       bottomNavigationBar: const AdBanner(),
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: tintColor.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE, d MMM yyyy').format(date),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey.shade900,
                ),
              ),
              const SizedBox(height: 12),
              ...allPrayers.map((prayerName) {
                final booking = provider.getBooking(date, prayerName);
                final isBooked = booking != null;
                final isCompleted = booking?.isCompleted ?? false;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          prayerName,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isBooked
                                ? FontWeight.w500
                                : FontWeight.normal,
                            color: isBooked
                                ? Colors.black87
                                : Colors.grey.shade600,
                            decoration: isBooked
                                ? null
                                : TextDecoration.lineThrough,
                            decorationColor: Colors.grey.shade400,
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
                                  'Prayer not booked yet. Book it from the specific date page.',
                                ),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? Colors.green.shade600
                                : isBooked
                                ? const Color.fromARGB(255, 177, 178, 178)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isBooked
                                  ? Colors.transparent
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: isBooked
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18,
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
