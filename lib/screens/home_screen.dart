import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';
import '../widgets/ad_banner.dart';
import 'date_detail_screen.dart';

// Import isSameDay utility
bool isSameDay(DateTime? a, DateTime? b) {
  if (a == null || b == null) return false;
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image - Full Cover
          Positioned.fill(
            child: Image.asset('assets/img2.jpg', fit: BoxFit.cover),
          ),
          // Semi-transparent overlay for better readability
          Positioned.fill(
            child: Container(color: Colors.white.withOpacity(0.2)),
          ),
          // Content
          Consumer<BookingProvider>(
            builder: (context, provider, child) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      'Ramadan  Notebook',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Calendar Container with padding
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.45),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.10),
                              blurRadius: 16,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: TableCalendar(
                          firstDay: DateTime.utc(2024, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          focusedDay: _focusedDay,
                          calendarFormat: _calendarFormat,

                          selectedDayPredicate: (day) =>
                              isSameDay(provider.selectedDate, day),

                          onDaySelected: (selectedDay, focusedDay) {
                            provider.setSelectedDate(selectedDay);
                            setState(() => _focusedDay = focusedDay);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DateDetailScreen(),
                              ),
                            );
                          },

                          onFormatChanged: (format) {
                            if (_calendarFormat != format) {
                              setState(() => _calendarFormat = format);
                            }
                          },

                          onPageChanged: (focusedDay) {
                            setState(() => _focusedDay = focusedDay);
                          },

                          calendarBuilders: CalendarBuilders(
                            markerBuilder: (context, date, events) {
                              final bookingCount = provider.getBookingCount(
                                date,
                              );

                              if (bookingCount == 0) return null;

                              // Number badge system
                              Color badgeColor = const Color.fromARGB(255, 255, 255, 255); // Green background
                              Color numberColor;
                              if (bookingCount == 1) {
                                numberColor = const Color.fromARGB(255, 232, 144, 2); // Yellow
                              } else if (bookingCount == 2) {
                                numberColor = const Color.fromARGB(255, 1, 92, 250); // Blue
                              } else {
                                numberColor = const Color.fromARGB(255, 2, 228, 17); // Green
                              }
                              return Positioned(
                                right: 3,
                                bottom: 1,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: badgeColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: badgeColor.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    '$bookingCount',
                                    style: TextStyle(
                                      color: numberColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          calendarStyle: CalendarStyle(
                            outsideDaysVisible: false,

                            defaultTextStyle: const TextStyle(
                              color: Color.fromARGB(255, 67, 67, 67),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),

                            weekendTextStyle: const TextStyle(
                              color: Color.fromARGB(255, 148, 28, 28),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),

                            todayDecoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color.fromARGB(255, 152, 233, 251),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),

                            /// 🔵 Selected Day — premium circular with outer ring
                            selectedDecoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color.fromARGB(164, 105, 165, 101),
                              border: Border.all(
                                color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.35),
                                width: 2, // creates ~40px visual size
                              ),
                            ),

                            todayTextStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade900,
                              fontWeight: FontWeight.w600,
                            ),

                            selectedTextStyle: const TextStyle(
                              letterSpacing: -0.5,
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            titleTextStyle: TextStyle(
                              color: Colors.grey.shade900,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.5,
                            ),
                            leftChevronIcon: Icon(
                              Icons.chevron_left,
                              color: Colors.grey.shade700,
                            ),
                            rightChevronIcon: Icon(
                              Icons.chevron_right,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Helper text
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Text(
                      'Select a date to view or add bookings',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 54, 54, 54),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  
                  const Spacer(),
                ],
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const AdBanner(),
    );
  }
}
