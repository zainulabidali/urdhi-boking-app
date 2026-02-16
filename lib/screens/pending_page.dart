import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/booking_provider.dart';

class PendingPage extends StatelessWidget {
  const PendingPage({super.key});

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
            final startDate = DateTime.utc(now.year, now.month, now.day);

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
              itemCount: 30,
              itemBuilder: (context, index) {
                final date = startDate.add(Duration(days: index));

                final pending = provider.allPrayers
                    .where((p) => provider.getBooking(date, p) == null)
                    .toList();

                if (pending.isEmpty) return const SizedBox();

                final allPending = pending.length == provider.allPrayers.length;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      /// DATE
                      SizedBox(width: 30,),
                      SizedBox(
                        // width: 70,
                        child: Text(
                          DateFormat('d  MMM').format(date),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Spacer(),

                      /// CHIPS
                      Expanded(
                        child: Wrap(
                          spacing: 6,
                          runSpacing: -6,
                          children: allPending
                              ? [
                                  _buildChip(
                                    "All Pending",
                                    const Color.fromARGB(255, 255, 68, 55),
                                  ),
                                ]
                              : pending.length >= 3
                              ? [_buildChip(pending.join(', '), const Color.fromARGB(255, 241, 82, 71))]
                              : pending
                                    .map(
                                      (p) => _buildChip(
                                        p,
                                        const Color.fromARGB(255, 251, 187, 90),
                                      ),
                                    )
                                    .toList(),
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

  Widget _buildChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(.18),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color.withOpacity(0.9),
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),
    );
  }
}
