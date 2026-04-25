import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SessionCompleteCard extends StatelessWidget {
  final String bookId;
  final String chapterId;

  const SessionCompleteCard({
    super.key,
    required this.bookId,
    required this.chapterId,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, size: 100, color: Colors.greenAccent),
            const SizedBox(height: 24),
            const Text(
              "Session Complete!",
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              "You did great. Reading in chunks helps you retain more information without feeling overwhelmed.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                // Navigate back to chapter list
                context.goNamed('chapters', pathParameters: {'id': bookId});
              },
              child: const Text("Continue to Chapters", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

