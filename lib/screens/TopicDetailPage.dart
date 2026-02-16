import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TopicDetailPage extends StatelessWidget {
  final String title;
  final String content;

  const TopicDetailPage({
    super.key,
    required this.title,
    required this.content,
  });

  bool get _isArabic => RegExp(r'[\u0600-\u06FF]').hasMatch(content);

  @override
  Widget build(BuildContext context) {
    // Elegant off-white/cream background
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF9F9F9),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF2C5F5F),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.bookmark_border_rounded,
              color: Color(0xFF2C5F5F),
            ),
            onPressed: () {
              // Placeholder for bookmark functionality
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Bookmark saved')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF2C5F5F)),
            onPressed: () {
              // Placeholder for share functionality
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title Section
              Text(
                title,
                textAlign: _isArabic ? TextAlign.right : TextAlign.left,
                textDirection: _isArabic
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C5F5F), // Deep Teal
                  height: 1.3,
                  fontFamily: 'Serif', // Fallback to Serif for elegance
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),

              // Decorative Divider
              Center(
                child: Container(
                  width: 60,
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC5A059), // Muted Gold Accent
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Content Section
              Text(
                content,
                textAlign: _isArabic ? TextAlign.left : TextAlign.left,
                textDirection: _isArabic
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                style: const TextStyle(
                  fontSize: 17,
                  height: 1.8, // Comfortable reading height
                  color: Color(0xFF4A4A4A), // Soft dark grey for readability
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
