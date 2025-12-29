import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/booking.dart';
import '../providers/booking_provider.dart';
import '../widgets/ad_banner.dart';

class BookingFormScreen extends StatefulWidget {
  final PrayerType prayerType;
  final Booking? booking;

  const BookingFormScreen({super.key, required this.prayerType, this.booking});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _mosqueController;
  late TextEditingController _locationController;
  late TextEditingController _mobileController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _mosqueController = TextEditingController(
      text: widget.booking?.mosqueName ?? '',
    );
    _locationController = TextEditingController(
      text: widget.booking?.location ?? '',
    );
    _mobileController = TextEditingController(
      text: widget.booking?.mobileNumber ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.booking?.description ?? '',
    );
  }

  @override
  void dispose() {
    _mosqueController.dispose();
    _locationController.dispose();
    _mobileController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveBooking() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<BookingProvider>(context, listen: false);
      final newBooking = Booking(
        mosqueName: _mosqueController.text.trim(),
        location: _locationController.text.trim(),
        mobileNumber: _mobileController.text.trim(),
        description: _descriptionController.text.trim(),
        date: provider.selectedDate,
        prayerType: widget.prayerType,
      );

      provider.saveBooking(newBooking);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Booking saved successfully!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  void _clearBooking() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Clear Booking?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade900,
          ),
        ),
        content: Text(
          'This will delete the booking details for this prayer.',
          style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          TextButton(
            onPressed: () {
              final provider = Provider.of<BookingProvider>(
                context,
                listen: false,
              );
              provider.clearBooking(provider.selectedDate, widget.prayerType);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to Detail Screen

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Booking cleared.'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.all(16),
                ),
              );
            },
            child: Text(
              'Clear',
              style: TextStyle(
                color: Colors.red.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.booking != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Booking' : 'New Booking',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (isEditing)
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
              onPressed: _clearBooking,
              tooltip: 'Delete booking',
            ),
        ],
      ),
      extendBodyBehindAppBar: true,
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
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: 100,
              left: 24,
              right: 24,
              bottom: 24,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Prayer Name Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.grey.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _getPrayerName(widget.prayerType),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade900,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Mosque Name Field
                  TextFormField(
                    controller: _mosqueController,
                    decoration: InputDecoration(
                      labelText: 'Mosque Name',
                      labelStyle: TextStyle(color: Colors.grey.shade600),
                      prefixIcon: Icon(
                        Icons.mosque,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter mosque name';
                      }
                      return null;
                    },
                    style: TextStyle(color: Colors.grey.shade900, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  // Location Field
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Place / Location',
                      labelStyle: TextStyle(color: Colors.grey.shade600),
                      prefixIcon: Icon(
                        Icons.location_on,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    style: TextStyle(color: Colors.grey.shade900, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  // Mobile Number Field
                  TextFormField(
                    controller: _mobileController,
                    decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      labelStyle: TextStyle(color: Colors.grey.shade600),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: Colors.grey.shade900, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  // Description Field
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description / Notes',
                      labelStyle: TextStyle(color: Colors.grey.shade600),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 60),
                        child: Icon(Icons.notes, color: Colors.grey.shade400),
                      ),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 5,
                    style: TextStyle(color: Colors.grey.shade900, fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  // Save Button
                  ElevatedButton(
                    onPressed: _saveBooking,
                    child: Text(isEditing ? 'Update Booking' : 'Save Booking'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AdBanner(),
    );
  }

  String _getPrayerName(PrayerType type) {
    switch (type) {
      case PrayerType.dhuhr:
        return 'Dhuhr';
      case PrayerType.asr:
        return 'Asr';
      case PrayerType.maghrib:
        return 'Maghrib';
    }
  }
}
