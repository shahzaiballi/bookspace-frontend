
import 'package:flutter/material.dart';
import 'package:fyp_future/features/home/widgets/book_reading_card.dart';
import 'package:fyp_future/features/home/widgets/continue_reading.dart';
import 'package:fyp_future/features/home/widgets/search_bar.dart';
import 'package:fyp_future/features/home/widgets/search_title.dart';

import 'model/dummy_Data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/bg.jpg", fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.7)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const GlowingSearchBar(),
                          const SizedBox(height: 24),

                          const ContinueReadingCard(),
                          const SizedBox(height: 6),

                          const SectionTitle(title: "Recommended For You"),
                          const SizedBox(height: 2),
                          SizedBox(
                            height: 250,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: recommendedBooks.length,
                              itemBuilder: (context, index) {
                                return BookCard(book: recommendedBooks[index]);
                              },
                            ),
                          ),

                          const SizedBox(height: 6),

                          const SectionTitle(title: "Recently Added"),
                          const SizedBox(height: 2),
                          SizedBox(
                            height: 250,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: recommendedBooks.length,
                              itemBuilder: (context, index) {
                                return BookCard(book: recommendedBooks[index]);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
