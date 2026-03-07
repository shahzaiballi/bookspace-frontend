import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/responsive_utils.dart';
import '../controllers/home_controller.dart';
import '../widgets/currently_reading_card.dart';
import '../widgets/insights_grid.dart';
import '../widgets/minimal_book_row_card.dart';
import '../widgets/horizontal_book_list.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../../library/pages/library_page.dart';
import '../../discussions/pages/discussions_page.dart';
import '../../profile/pages/profile_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (_currentIndex != 0) {
      Widget bodyContent;
      if (_currentIndex == 1) {
        bodyContent = const LibraryPage();
      } else if (_currentIndex == 2) {
        bodyContent = const DiscussionsPage();
      } else if (_currentIndex == 3) {
        bodyContent = const ProfilePage();
      } else {
        // Fallback for non existing
        bodyContent = Center(child: Text("Tab $_currentIndex Content", style: const TextStyle(color: Colors.white)));
      }

      return Scaffold(
        backgroundColor: const Color(0xFF0F1626),
        body: bodyContent,
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      );
    }

    final currentProgress = ref.watch(currentProgressProvider);
    final insights = ref.watch(insightsProvider);
    final recommendedBooks = ref.watch(recommendedBooksProvider);
    final trendingBooks = ref.watch(trendingBooksProvider);
    final libraryBooks = ref.watch(libraryBooksProvider);

    return Scaffold(
       backgroundColor: const Color(0xFF0F1626), 
       bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
       ),
       body: SafeArea(
         child: LayoutBuilder(
           builder: (context, constraints) {
             return Center(
               child: ConstrainedBox(
                 constraints: BoxConstraints(maxWidth: context.responsive.isLandscape ? 800 : double.infinity),
                 child: CustomScrollView(
                   slivers: [
                     // Native Header
                     SliverAppBar(
                       backgroundColor: const Color(0xFF0F1626),
                       floating: true,
                       elevation: 0,
                       title: Padding(
                         padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(4)),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Row(
                               children: [
                                  Text(
                                    'Good evening, Ali ', 
                                    style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(22), fontWeight: FontWeight.bold)
                                  ),
                                  Text('👋', style: TextStyle(fontSize: context.responsive.sp(20))),
                               ],
                             ),
                             Text(
                                'Ready to continue your reading journey?',
                                style: TextStyle(color: Colors.white54, fontSize: context.responsive.sp(14)),
                             )
                           ],
                         ),
                       ),
                       toolbarHeight: context.responsive.sp(80),
                     ),
                     
                     // Currently Reading
                     SliverToBoxAdapter(
                        child: _buildAsyncWidget(
                           asyncValue: currentProgress, 
                           builder: (data) => Padding(
                             padding: EdgeInsets.only(bottom: context.responsive.sp(32)),
                             child: CurrentlyReadingCard(progress: data),
                           )
                        )
                     ),

                     // Insights
                     SliverToBoxAdapter(
                        child: _buildAsyncWidget(
                           asyncValue: insights, 
                           builder: (data) => Padding(
                             padding: EdgeInsets.only(bottom: context.responsive.sp(32)),
                             child: InsightsGrid(insights: data),
                           )
                        )
                     ),

                     // Recommended Books Header
                     SliverToBoxAdapter(
                       child: Padding(
                         padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(20), vertical: context.responsive.sp(8)),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                              Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Row(
                                     children: [
                                       Text("Recommended for You", style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(18), fontWeight: FontWeight.bold)),
                                       SizedBox(width: context.responsive.wp(8)),
                                       Icon(Icons.star, color: const Color(0xFFB062FF), size: context.responsive.sp(16)),
                                     ],
                                   ),
                                   TextButton(
                                     onPressed: () {},
                                     child: Row(
                                       children: [
                                         Text('See All', style: TextStyle(color: const Color(0xFFB062FF), fontSize: context.responsive.sp(13))),
                                         Icon(Icons.arrow_forward, color: const Color(0xFFB062FF), size: context.responsive.sp(14))
                                       ],
                                     ),
                                   )
                                 ],
                              ),
                              Text("Based on your interest in Self-Improvement & Productivity", style: TextStyle(color: Colors.white54, fontSize: context.responsive.sp(12))),
                              SizedBox(height: context.responsive.sp(8)),
                           ],
                         )
                       ),
                     ),

                     // Recommended Books List
                     recommendedBooks.when(
                       data: (books) => SliverList(
                          delegate: SliverChildBuilderDelegate(
                            childCount: books.length,
                            (context, index) => MinimalBookRowCard(book: books[index]),
                          ),
                       ),
                       loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB062FF))))),
                       error: (e, st) => SliverToBoxAdapter(child: Center(child: Text('Error: $e', style: const TextStyle(color: Colors.redAccent)))),
                     ),

                     SliverToBoxAdapter(child: SizedBox(height: context.responsive.sp(32))),

                     // Trending Books
                     SliverToBoxAdapter(
                        child: _buildAsyncWidget(
                           asyncValue: trendingBooks, 
                           builder: (data) => Padding(
                             padding: EdgeInsets.only(bottom: context.responsive.sp(32)),
                             child: HorizontalBookList(title: 'Trending This Week', books: data, showBadges: true),
                           )
                        )
                     ),

                     // Library Books
                     SliverToBoxAdapter(
                        child: _buildAsyncWidget(
                           asyncValue: libraryBooks, 
                           builder: (data) => Padding(
                             padding: EdgeInsets.only(bottom: context.responsive.sp(32)),
                             child: HorizontalBookList(title: 'Your Library', books: data, showsAuthor: false),
                           )
                        )
                     ),
                   ],
                 ),
               ),
             );
           }
         ),
       ),
    );
  }

  Widget _buildAsyncWidget<T>({required AsyncValue<T> asyncValue, required Widget Function(T) builder}) {
     return asyncValue.when(
       data: builder,
       loading: () => const Center(child: Padding(
         padding: EdgeInsets.all(24.0),
         child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB062FF))),
       )),
       error: (e, st) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.redAccent))),
     );
  }
}
