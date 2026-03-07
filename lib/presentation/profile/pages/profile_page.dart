import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/stat_card.dart';
import '../widgets/achievement_tile.dart';
import '../widgets/settings_tile.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
       context: context,
       builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1E233D),
          title: Text('Log Out', style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(18), fontWeight: FontWeight.bold)),
          content: Text('Are you sure you want to log out?', style: TextStyle(color: Colors.white70, fontSize: context.responsive.sp(14))),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.responsive.sp(16))),
          actions: [
             TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: Colors.white54, fontSize: context.responsive.sp(14))),
             ),
             TextButton(
                onPressed: () {
                   Navigator.pop(context);
                   context.go('/login');
                },
                child: Text('Log Out', style: TextStyle(color: Colors.redAccent, fontSize: context.responsive.sp(14), fontWeight: FontWeight.bold)),
             ),
          ],
       )
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileControllerProvider);
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);
    final darkModeEnabled = ref.watch(darkModeEnabledProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F1626),
      body: SafeArea(
         child: profileAsync.when(
            data: (profile) {
               return CustomScrollView(
                  slivers: [
                     // Native Header
                     SliverAppBar(
                        backgroundColor: const Color(0xFF0F1626),
                        floating: true,
                        elevation: 0,
                        title: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                              Text('Profile', style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(24), fontWeight: FontWeight.bold)),
                              IconButton(
                                 icon: Icon(Icons.settings_outlined, color: Colors.white54, size: context.responsive.sp(22)),
                                 onPressed: () {},
                                 padding: EdgeInsets.zero,
                                 constraints: const BoxConstraints(),
                              )
                           ],
                        ),
                     ),
                     
                     SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(20)),
                        sliver: SliverList(
                           delegate: SliverChildListDelegate([
                              SizedBox(height: context.responsive.sp(16)),
                              
                              ProfileHeaderCard(userProfile: profile),
                              
                              SizedBox(height: context.responsive.sp(24)),
                              
                              // Reading Statistics Header
                              Text('Reading Statistics', style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(16), fontWeight: FontWeight.bold)),
                              SizedBox(height: context.responsive.sp(12)),
                              
                              // Stats Row
                              Row(
                                 children: [
                                    StatCard(icon: Icons.menu_book, value: '${profile.booksRead}', label: 'Books Read'),
                                    StatCard(icon: Icons.trending_up, value: '${profile.totalPages}', label: 'Total Pages'),
                                    StatCard(icon: Icons.military_tech, value: '${profile.currentStreak} days', label: 'Current Streak'),
                                 ],
                              ),
                              
                              SizedBox(height: context.responsive.sp(28)),

                              // Recent Achievements Header
                              Text('Recent Achievements', style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(16), fontWeight: FontWeight.bold)),
                              SizedBox(height: context.responsive.sp(12)),

                              // Achievement List
                              ...profile.achievements.where((a) => a.isUnlocked).map(
                                 (achievement) => AchievementTile(achievement: achievement)
                              ),

                              SizedBox(height: context.responsive.sp(28)),

                              // Preferences Header
                              Text('Preferences', style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(16), fontWeight: FontWeight.bold)),
                              SizedBox(height: context.responsive.sp(12)),

                              // Preference Tiles
                              SettingsTile(
                                 icon: Icons.schedule,
                                 title: 'Reading Plan Preferences',
                                 subtitle: 'Customize your reading schedule',
                                 trailing: Icon(Icons.chevron_right, color: Colors.white54, size: context.responsive.sp(20)),
                                 onTap: () => context.push('/reading_plan'),
                              ),
                              SettingsTile(
                                 icon: Icons.show_chart,
                                 title: 'Difficulty Level',
                                 subtitle: 'Intermediate',
                                 trailing: Icon(Icons.chevron_right, color: Colors.white54, size: context.responsive.sp(20)),
                                 onTap: () {},
                              ),

                              SizedBox(height: context.responsive.sp(8)),

                              // Toggle Switches
                              SettingsTile(
                                 icon: Icons.notifications_outlined,
                                 title: 'Notifications',
                                 subtitle: notificationsEnabled ? 'Enabled' : 'Disabled',
                                 trailing: Switch.adaptive(
                                    value: notificationsEnabled,
                                    onChanged: (val) => ref.read(notificationsEnabledProvider.notifier).state = val,
                                    activeColor: const Color(0xFFB062FF),
                                 ),
                              ),
                              SettingsTile(
                                 icon: Icons.dark_mode_outlined,
                                 title: 'Dark Mode',
                                 subtitle: darkModeEnabled ? 'Always on' : 'Off',
                                 trailing: Switch.adaptive(
                                    value: darkModeEnabled,
                                    onChanged: (val) => ref.read(darkModeEnabledProvider.notifier).state = val,
                                    activeColor: const Color(0xFFB062FF),
                                 ),
                              ),

                              SizedBox(height: context.responsive.sp(28)),

                              // Log Out Action Button
                              SizedBox(
                                 width: double.infinity,
                                 height: context.responsive.sp(52),
                                 child: OutlinedButton.icon(
                                    onPressed: () => _showLogoutDialog(context, ref),
                                    icon: Icon(Icons.logout, color: Colors.redAccent, size: context.responsive.sp(20)),
                                    label: Text('Log Out', style: TextStyle(color: Colors.redAccent, fontSize: context.responsive.sp(15), fontWeight: FontWeight.bold)),
                                    style: OutlinedButton.styleFrom(
                                       side: const BorderSide(color: Colors.redAccent, width: 1.5),
                                       backgroundColor: Colors.redAccent.withOpacity(0.05),
                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.responsive.sp(12))),
                                    ),
                                 ),
                              ),

                              SizedBox(height: context.responsive.sp(100)), // Bottom padding giving scroll space over Nav Bar
                           ])
                        )
                     )
                  ],
               );
            },
            loading: () => const Center(child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB062FF)))),
            error: (e, st) => Center(child: Text('Error loading profile: $e', style: const TextStyle(color: Colors.redAccent))),
         )
      ),
    );
  }
}
