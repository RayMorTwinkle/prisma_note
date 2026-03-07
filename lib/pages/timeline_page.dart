import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/timeline_item.dart';
import '../widgets/sound_wave_visualizer.dart';
import '../providers/timeline_provider.dart';
import '../widgets/cards/timeline_item_card.dart';
import '../widgets/sheets/search_sheet.dart';
import '../constants/app_colors.dart';

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

  List<TimelineItem> get _filteredItems {
    final timelineProvider = Provider.of<TimelineProvider>(context, listen: false);
    final allItems = timelineProvider.timelineItems;
    
    return allItems
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
              primary: AppColors.primary,
              onPrimary: AppColors.onPrimary,
              surface: AppColors.surface,
              onSurface: AppColors.onSurface,
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
    return Consumer<TimelineProvider>(
      builder: (context, timelineProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _showDatePicker,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.grey300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: AppColors.grey600,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${_selectedDate.day}/${_selectedDate.month}',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Center(
                            child: SoundWaveVisualizer(
                              isActive: false,
                            ),
                          ),
                        ),
                      ),
                      
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: AppColors.surface,
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
                            border: Border.all(color: AppColors.grey300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.search,
                            size: 20,
                            color: AppColors.grey600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
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
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.grey100,
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
                                      color: !_isDetailView ? AppColors.primary : null,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Simple',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: !_isDetailView ? AppColors.onPrimary : AppColors.grey600,
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
                                      color: _isDetailView ? AppColors.primary : null,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Detail',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: _isDetailView ? AppColors.onPrimary : AppColors.grey600,
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
                            color: AppColors.grey600,
                          ),
                        ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: _filteredItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.timeline,
                                size: 64,
                                color: AppColors.grey400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No items for this date',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: AppColors.grey600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Try a different date or add some items',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.grey500,
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
      },
    );
  }
}
