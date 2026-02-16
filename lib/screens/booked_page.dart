import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/booking_provider.dart';

class BookedPage extends StatelessWidget {
  const BookedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/img2.jpg', fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: Container(color: Colors.black.withOpacity(0.35)),
        ),
        Consumer<BookingProvider>(
          builder: (context, provider, child) {
            final now = DateTime.now();
            final startDate =
                DateTime.utc(now.year, now.month, now.day);

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
              itemCount: 30,
              separatorBuilder: (_, __) =>
                  Divider(color: const Color.fromARGB(0, 255, 255, 255).withOpacity(0.0)),
              itemBuilder: (context, index) {
                final date =
                    startDate.add(Duration(days: index));

                final booked = provider.allPrayers
                    .where((p) =>
                        provider.getBooking(date, p) != null)
                    .toList();

                if (booked.isEmpty) return const SizedBox();

                final fullyBooked =
                    booked.length == provider.allPrayers.length;

                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 22),

                      const SizedBox(width: 10),

                      /// DATE
                      SizedBox(
                        width: 70,
                        child: Text(
                          DateFormat('d MMM').format(date),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      /// STATUS
                      Expanded(
                        child: Text(
                          fullyBooked
                              ? "Fully booked"
                              : booked.join(', '),
                          style: TextStyle(
                            color: fullyBooked
                                ? Colors.greenAccent
                                : Colors.white70,
                            fontWeight: fullyBooked
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
