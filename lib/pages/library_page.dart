import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prisma_note/models/contact.dart';

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Library',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            
            // Tasks Section
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
            
            // Contacts Section
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
            
            // Memos Section
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
            
            // Health Section
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
            
            // Additional spacing at bottom
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
          color: Colors.black,
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
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: Colors.grey[700],
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
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Colors.grey[400],
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
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: Colors.grey[700],
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
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '2024 Overview & Planning',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.grey[600],
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
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '2024',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Colors.grey[400],
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
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showTasksYearView() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
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
      backgroundColor: Colors.white,
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
      backgroundColor: Colors.white,
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

class TasksYearViewSheet extends StatelessWidget {
  const TasksYearViewSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '2024 Tasks Overview',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Annual planning and goal tracking',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Mock chart visualization
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bar_chart,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Tasks Chart Visualization',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Coming in next update',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ContactsListSheet extends StatelessWidget {
  final List<Contact> contacts;
  final String? title;

  const ContactsListSheet({
    super.key,
    required this.contacts,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  title ?? 'All Contacts',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${contacts.length} contacts',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                
                ...contacts.map((contact) => _buildContactCard(context, contact)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactCard(BuildContext context, Contact contact) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Text(
                    contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        contact.type.displayName,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey[600],
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
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    contact.type.displayName,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            
            if (contact.email != null || contact.phone != null) ...[
              const SizedBox(height: 12),
              if (contact.email != null)
                Row(
                  children: [
                    Icon(
                      Icons.email,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      contact.email!,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              if (contact.phone != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      contact.phone!,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ],
            
            if (contact.tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: contact.tags.take(3).map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tag,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: Colors.grey[700],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}