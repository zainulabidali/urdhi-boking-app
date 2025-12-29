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
            child: Image.asset('assets/img1.jpg', fit: BoxFit.cover),
          ),
          // Semi-transparent overlay for better readability
          Positioned.fill(
            child: Container(color: Colors.white.withOpacity(0.3)),
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
                    padding: const EdgeInsets.all(26),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.45),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.45),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
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

                              Color dotColor = bookingCount == 1
                                  ? Colors.amber.shade500
                                  : bookingCount == 2
                                  ? Colors.blue.shade500
                                  : Colors.green.shade500;

                              return Positioned(
                                right: 4,
                                bottom: 4,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: dotColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: dotColor.withOpacity(0.4),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
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
                              color: const Color.fromARGB(255, 125, 125, 129),
                              border: Border.all(
                                color: const Color.fromARGB(
                                  255,
                                  0,
                                  0,
                                  0,
                                ).withOpacity(0.35),
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
                        color: Colors.grey.shade600,
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
