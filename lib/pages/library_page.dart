import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/contact.dart';
import '../widgets/sheets/tasks_year_view_sheet.dart';
import '../widgets/sheets/contacts_list_sheet.dart';
import '../constants/app_colors.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final List<Contact> _sampleContacts = [
    Contact(
      id: '1',
      name: 'Alice Johnson',
      email: 'alice@company.com',
      phone: '+1-555-0123',
      type: ContactType.work,
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
      lastContact: DateTime.now().subtract(const Duration(days: 2)),
      tags: ['colleague', 'design team', 'senior'],
    ),
    Contact(
      id: '2',
      name: 'Bob Smith',
      email: 'bob@example.com',
      phone: '+1-555-0124',
      type: ContactType.client,
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
      lastContact: DateTime.now().subtract(const Duration(days: 5)),
      tags: ['client', 'web development', 'priority'],
    ),
    Contact(
      id: '3',
      name: 'Sarah Davis',
      email: 'sarah@personal.com',
      phone: '+1-555-0125',
      type: ContactType.personal,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      lastContact: DateTime.now().subtract(const Duration(days: 1)),
      tags: ['friend', 'college', 'travel'],
    ),
    Contact(
      id: '4',
      name: 'Dr. Michael Chen',
      email: 'mchen@healthcenter.com',
      phone: '+1-555-0126',
      type: ContactType.service,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      lastContact: DateTime.now().subtract(const Duration(days: 30)),
      tags: ['doctor', 'health', 'annual checkup'],
    ),
    Contact(
      id: '5',
      name: 'Mom (Carol Williams)',
      email: 'carol.williams@email.com',
      phone: '+1-555-0127',
      type: ContactType.family,
      createdAt: DateTime.now().subtract(const Duration(days: 365 * 25)),
      lastContact: DateTime.now().subtract(const Duration(days: 3)),
      tags: ['family', 'mother', 'important'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Library',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            
            SliverToBoxAdapter(
              child: _buildSectionHeader('Tasks'),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                _buildTasksTile(),
                _buildSettingsTile(
                  icon: Icons.calendar_view_month,
                  title: 'Month View',
                  subtitle: 'Current month tasks and goals',
                  onTap: () => _showComingSoon('Month View'),
                ),
                _buildSettingsTile(
                  icon: Icons.calendar_view_day,
                  title: 'Day View',
                  subtitle: 'Daily task breakdown',
                  onTap: () => _showComingSoon('Day View'),
                ),
              ]),
            ),
            
            SliverToBoxAdapter(
              child: _buildSectionHeader('Contacts'),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                _buildSettingsTile(
                  icon: Icons.contacts,
                  title: 'All Contacts',
                  subtitle: '${_sampleContacts.length} contacts',
                  onTap: () => _showContactsList(),
                ),
                _buildSettingsTile(
                  icon: Icons.business,
                  title: 'Work Contacts',
                  subtitle: '${_getContactsByType(ContactType.work).length} colleagues',
                  onTap: () => _showContactsByType(ContactType.work),
                ),
                _buildSettingsTile(
                  icon: Icons.family_restroom,
                  title: 'Family',
                  subtitle: '${_getContactsByType(ContactType.family).length} family members',
                  onTap: () => _showContactsByType(ContactType.family),
                ),
              ]),
            ),
            
            SliverToBoxAdapter(
              child: _buildSectionHeader('Memos'),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                _buildSettingsTile(
                  icon: Icons.lightbulb,
                  title: 'Second Brain',
                  subtitle: 'Ideas and insights',
                  onTap: () => _showComingSoon('Second Brain'),
                ),
                _buildSettingsTile(
                  icon: Icons.bookmark,
                  title: 'Bookmarks',
                  subtitle: 'Saved content and references',
                  onTap: () => _showComingSoon('Bookmarks'),
                ),
                _buildSettingsTile(
                  icon: Icons.star,
                  title: 'Favorites',
                  subtitle: 'Important memos and notes',
                  onTap: () => _showComingSoon('Favorites'),
                ),
              ]),
            ),
            
            SliverToBoxAdapter(
              child: _buildSectionHeader('Health'),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                _buildSettingsTile(
                  icon: Icons.monitor_heart,
                  title: 'Activity Charts',
                  subtitle: 'Daily activity overview',
                  onTap: () => _showComingSoon('Activity Charts'),
                ),
                _buildSettingsTile(
                  icon: Icons.fitness_center,
                  title: 'Exercise Tracking',
                  subtitle: 'Workout history and goals',
                  onTap: () => _showComingSoon('Exercise Tracking'),
                ),
                _buildSettingsTile(
                  icon: Icons.water_drop,
                  title: 'Wellness Metrics',
                  subtitle: 'Sleep, hydration, and mood',
                  onTap: () => _showComingSoon('Wellness Metrics'),
                ),
              ]),
            ),
            
            const SliverToBoxAdapter(
              child: SizedBox(height: 32),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: AppColors.grey700,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: AppColors.grey400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTasksTile() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showTasksYearView(),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: AppColors.grey700,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Year View',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '2024 Overview & Planning',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '2024',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: AppColors.grey400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Contact> _getContactsByType(ContactType type) {
    return _sampleContacts.where((contact) => contact.type == type).toList();
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon!'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showTasksYearView() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const TasksYearViewSheet(),
    );
  }

  void _showContactsList() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ContactsListSheet(contacts: _sampleContacts),
    );
  }

  void _showContactsByType(ContactType type) {
    final filteredContacts = _getContactsByType(type);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ContactsListSheet(
        contacts: filteredContacts,
        title: type.displayName,
      ),
    );
  }
}
