import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/timeline_item.dart';
import '../../utils/date_utils.dart' as app_date_utils;
import '../../constants/app_colors.dart';

class TimelineItemCard extends StatelessWidget {
  final TimelineItem item;
  final bool isDetailView;

  const TimelineItemCard({
    super.key,
    required this.item,
    required this.isDetailView,
  });

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
            Row(
              children: [
                Text(
                  app_date_utils.AppDateUtils.formatRelativeTime(item.timestamp),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey600,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  _typeIcon,
                  size: 16,
                  color: AppColors.grey600,
                ),
                const Spacer(),
                if (item.isFavorite)
                  Icon(
                    Icons.star,
                    size: 16,
                    color: AppColors.amber600,
                  ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Text(
              item.title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            
            if (isDetailView) ...[
              if (item.summary != null) ...[
                const SizedBox(height: 8),
                Text(
                  item.summary!,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.grey700,
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
                      color: AppColors.grey600,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.participants.join(', '),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.grey600,
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
                    color: AppColors.grey100,
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
                            color: AppColors.grey600,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Generated ToDos',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.grey700,
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
                              color: AppColors.grey600,
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
