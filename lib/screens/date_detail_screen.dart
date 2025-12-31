import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/booking.dart';
import '../providers/booking_provider.dart';
import '../widgets/ad_banner.dart';
import 'booking_form_screen.dart';

class DateDetailScreen extends StatefulWidget {
  const DateDetailScreen({super.key});

  @override
  State<DateDetailScreen> createState() => _DateDetailScreenState();
}

  void _showAddExtraDialog(BuildContext context, BookingProvider provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Extra Prayer/Item'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Name',
            hintText: 'Enter custom prayer or item',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                provider.addCustomPrayer(name);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

class _DateDetailScreenState extends State<DateDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookingProvider>(context);
    final selectedDate = provider.selectedDate;
    final dateStr = DateFormat('EEEE, d MMMM yyyy').format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Day Schedule',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Image - Full Cover
          Positioned.fill(
            child: Image.asset('assets/img2.jpg', fit: BoxFit.cover),
          ),
          // Semi-transparent overlay for better readability
          Positioned.fill(
            child: Container(color: Colors.white.withOpacity(0.3)),
          ),
          // Content
          Column(
            children: [
              const SizedBox(height: 100), // Space for AppBar
              // Date Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white.withOpacity(0.85),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    dateStr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 51, 51, 51),
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Prayer Cards
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: provider.allPrayers.length,
                  itemBuilder: (context, index) {
                    final prayerName = provider.allPrayers[index];
                    final booking = provider.getBooking(
                      selectedDate,
                      prayerName,
                    );
                    final isBooked = booking != null;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingFormScreen(
                                  prayerName: prayerName,
                                  booking: booking,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.white.withOpacity(0.88),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.4),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 14,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            prayerName,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade900,
                                              letterSpacing: -0.3,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isBooked
                                                  ? const Color.fromARGB(
                                                      255,
                                                      202,
                                                      244,
                                                      205,
                                                    )
                                                  : const Color.fromARGB(
                                                      255,
                                                      225,
                                                      224,
                                                      224,
                                                    ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              isBooked
                                                  ? 'Booked'
                                                  : 'Not Booked',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: isBooked
                                                    ? const Color.fromARGB(
                                                        255,
                                                        30,
                                                        109,
                                                        34,
                                                      )
                                                    : const Color.fromARGB(
                                                        255,
                                                        101,
                                                        100,
                                                        100,
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (isBooked) ...[
                                        const SizedBox(height: 12),
                                        _infoText(booking.mosqueName, 15),
                                        _infoText(booking.location, 13),
                                        _infoText(booking.mobileNumber, 12),
                                        _infoText(booking.description, 11),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Add Extra Button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 8.0,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2C5F5F),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 2,
                        ),
                        icon: const Icon(Icons.add, size: 22),
                        label: const Text(
                          'Add Extra Prayer/Item',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () => _showAddExtraDialog(context, provider),
                      ),
                    ),
                  ),
              // const SizedBox(height: 16),
              // Ad Banner
              //  AdBanner(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: const AdBanner(),
    );
  }

  Widget _infoText(String text, double size) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        text,
        style: TextStyle(fontSize: size, color: Colors.grey.shade600),
      ),
    );
  }
}
