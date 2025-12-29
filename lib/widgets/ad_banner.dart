import 'package:flutter/material.dart';

/// Reusable bottom banner advertisement space widget
///
/// This widget provides a consistent ad banner placeholder
/// that appears at the bottom of screens. It's designed to be
/// easily replaceable with actual ad network integration in the future.
///
/// The banner:
/// - Has a standard height of 56px (50-60px range)
/// - Respects safe areas (notches, home indicators)
/// - Uses a neutral, non-intrusive design
/// - Is full-width and fixed at the bottom
class AdBanner extends StatelessWidget {
  const AdBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        height: 56, // Standard banner height (50-60px)
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        child: Center(
          child: Text(
            'Banner Ad',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
