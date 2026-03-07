import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/event_project.dart';
import '../constants/app_colors.dart';
import '../utils/date_utils.dart';

class ProjectCard extends StatelessWidget {
  final EventProject project;

  const ProjectCard({
    super.key,
    required this.project,
  });

  Color _getPriorityColor(String? priority) {
    switch (priority) {
      case 'high':
        return AppColors.red400;
      case 'medium':
        return AppColors.orange400;
      case 'low':
        return AppColors.green400;
      default:
        return AppColors.grey400;
    }
  }

  Color _getStatusColor(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.inProgress:
        return AppColors.blue400;
      case ProjectStatus.completed:
        return AppColors.green400;
      case ProjectStatus.onHold:
        return AppColors.orange400;
      case ProjectStatus.cancelled:
        return AppColors.red400;
      case ProjectStatus.backlog:
        return AppColors.grey400;
      case ProjectStatus.life:
        return AppColors.purple400;
    }
  }

  String _formatProgress(double progress) {
    return '${(progress * 100).toInt()}%';
  }

  String _getProgressLabel(double progress) {
    if (progress >= 1.0) return 'Complete';
    if (progress >= 0.8) return 'Almost done';
    if (progress >= 0.5) return 'Halfway';
    if (progress >= 0.2) return 'Just started';
    return 'Planning';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    project.title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (project.priority != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getPriorityColor(project.priority),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
            
            const SizedBox(height: 8),
            
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: _getStatusColor(project.status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getStatusColor(project.status).withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                project.status.displayName,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: _getStatusColor(project.status),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatProgress(project.progress),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      _getProgressLabel(project.progress),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: project.progress,
                  backgroundColor: AppColors.grey200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getStatusColor(project.status),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            if (project.description.isNotEmpty)
              Text(
                project.description,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.grey600,
                  height: 1.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            
            if (project.dueDate != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: AppColors.grey500,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Due: ${AppDateUtils.formatDate(project.dueDate!)}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),
            ],
            
            const Spacer(),
            
            Column(
              children: [
                if (project.tags.isNotEmpty) ...[
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: project.tags.take(3).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tag,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: AppColors.grey700,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                ],
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMetricChip(
                      icon: Icons.checklist,
                      label: 'Tasks',
                      value: '${_generateTaskCount()}',
                    ),
                    _buildMetricChip(
                      icon: Icons.schedule,
                      label: 'Schedules',
                      value: '${_generateScheduleCount()}',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color: AppColors.grey600,
        ),
        const SizedBox(width: 4),
        Text(
          '$label: $value',
          style: GoogleFonts.inter(
            fontSize: 10,
            color: AppColors.grey600,
          ),
        ),
      ],
    );
  }

  int _generateTaskCount() {
    return (5 + (project.progress * 20)).round();
  }

  int _generateScheduleCount() {
    final daysSinceCreated = DateTime.now().difference(project.createdAt).inDays;
    return (daysSinceCreated / 7).round();
  }
}
