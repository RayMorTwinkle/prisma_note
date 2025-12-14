import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prisma_note/models/timeline_item.dart';
import 'package:prisma_note/widgets/sound_wave_visualizer.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  bool _isDetailView = false;
  final TextEditingController _searchController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _searchQuery = '';

  final List<TimelineItem> _sampleTimelineItems = [
    TimelineItem(
      id: '1',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      title: 'Team Standup Meeting',
      summary: 'Discussed project progress, blockers, and upcoming sprint planning.',
      type: TimelineType.meeting,
      participants: ['Alice', 'Bob', 'Charlie'],
      generatedToDos: ['Update project documentation', 'Review pull requests'],
    ),
    TimelineItem(
      id: '2',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      title: 'Coffee with Sarah',
      summary: 'Casual catch-up about life and career plans.',
      type: TimelineType.event,
      participants: ['Sarah Johnson'],
      generatedToDos: ['Send follow-up email'],
    ),
    TimelineItem(
      id: '3',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      title: 'Grocery Shopping',
      summary: 'Weekly grocery run to Whole Foods. Bought fresh produce and pantry staples.',
      type: TimelineType.task,
      participants: [],
      generatedToDos: ['Meal prep on Sunday'],
    ),
    TimelineItem(
      id: '4',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      title: 'Voice Memo - Ideas for App',
      summary: 'Brainstorming session for new feature ideas while walking.',
      type: TimelineType.voiceMemo,
      participants: [],
      generatedToDos: ['Research similar apps', 'Create feature mockups'],
    ),
    TimelineItem(
      id: '5',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      title: 'Doctor Appointment',
      summary: 'Annual checkup. Everything looks good, just need to maintain current exercise routine.',
      type: TimelineType.event,
      participants: ['Dr. Smith'],
      generatedToDos: ['Schedule next year\'s appointment'],
    ),
  ];

  List<TimelineItem> get _filteredItems {
    return _sampleTimelineItems
        .where((item) =>
            _searchQuery.isEmpty ||
            item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (item.summary?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false))
        .where((item) =>
            item.timestamp.year == _selectedDate.year &&
            item.timestamp.month == _selectedDate.month &&
            item.timestamp.day == _selectedDate.day)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Date, VAD Visualizer, and Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Date Selector
                  GestureDetector(
                    onTap: _showDatePicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_selectedDate.day}/${_selectedDate.month}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Sound Wave Visualizer (VAD Status)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: SoundWaveVisualizer(),
                      ),
                    ),
                  ),
                  
                  // Search
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) => SearchSheet(
                          controller: _searchController,
                          onSearch: (query) {
                            setState(() {
                              _searchQuery = query;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // View Toggle and Search Results
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Timeline',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => setState(() => _isDetailView = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: !_isDetailView ? Colors.black : null,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Simple',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: !_isDetailView ? Colors.white : Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => _isDetailView = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _isDetailView ? Colors.black : null,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Detail',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: _isDetailView ? Colors.white : Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  if (_searchQuery.isNotEmpty)
                    Text(
                      '${_filteredItems.length} results',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
            
            // Timeline List
            Expanded(
              child: _filteredItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timeline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No items for this date',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try a different date or add some items',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return TimelineItemCard(
                          item: item,
                          isDetailView: _isDetailView,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimelineItemCard extends StatelessWidget {
  final TimelineItem item;
  final bool isDetailView;

  const TimelineItemCard({
    super.key,
    required this.item,
    required this.isDetailView,
  });

  String get _formattedTime {
    final now = DateTime.now();
    final difference = now.difference(item.timestamp);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  IconData get _typeIcon {
    switch (item.type) {
      case TimelineType.meeting:
        return Icons.group;
      case TimelineType.event:
        return Icons.event;
      case TimelineType.task:
        return Icons.check_circle;
      case TimelineType.voiceMemo:
        return Icons.mic;
      case TimelineType.note:
        return Icons.note;
      case TimelineType.reminder:
        return Icons.alarm;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Time and Type
            Row(
              children: [
                Text(
                  _formattedTime,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  _typeIcon,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const Spacer(),
                if (item.isFavorite)
                  Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.amber[600],
                  ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Title
            Text(
              item.title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            
            // Detail View Additional Content
            if (isDetailView) ...[
              if (item.summary != null) ...[
                const SizedBox(height: 8),
                Text(
                  item.summary!,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ],
              
              if (item.participants.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.participants.join(', '),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              
              if (item.generatedToDos.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.checklist,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Generated ToDos',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ...item.generatedToDos.map(
                        (todo) => Padding(
                          padding: const EdgeInsets.only(left: 22, bottom: 2),
                          child: Text(
                            '• $todo',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class SearchSheet extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;

  const SearchSheet({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search timeline...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: onSearch,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}