import 'package:flutter/material.dart';

import 'package:urdhi_tracker/widgets/ad_banner.dart';

import 'all_bookings_page.dart';
import 'booked_page.dart';
import 'pending_page.dart';

class BookingListScreen extends StatelessWidget {
  const BookingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.chevron_left),
            color: Colors.white,
            iconSize: 30,
            onPressed: () => Navigator.pop(context),
          ),

          title: const Text(
            'Booking List',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.black,

          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6, left: 15, right: 15),
              child: TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromARGB(
                    255,
                    255,
                    255,
                    255,
                  ).withOpacity(0.9),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: const Color.fromARGB(255, 6, 6, 6),
                unselectedLabelColor: const Color.fromARGB(235, 255, 255, 255),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                tabs: const [
                  Tab(text: "ALL"),
                  Tab(text: "BOOKED"),
                  Tab(text: "PENDING"),
                ],
              ),
            ),
          ),
        ),

        body: const TabBarView(
          children: [AllBookingsPage(), BookedPage(), PendingPage()],
        ),

        bottomNavigationBar: const AdBanner(),
      ),
    );
  }
}
