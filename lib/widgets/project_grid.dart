import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/event_project.dart';
import 'project_card.dart';
import '../constants/app_colors.dart';

class ProjectGrid extends StatelessWidget {
  final List<EventProject> projects;

  const ProjectGrid({
    super.key,
    required this.projects,
  });

  @override
  Widget build(BuildContext context) {
    if (projects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_outline,
              size: 64,
              color: AppColors.grey400,
            ),
            const SizedBox(height: 16),
            Text(
              'No projects here',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.grey600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add some projects to get started',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.grey500,
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        final childAspectRatio = constraints.maxWidth > 600 ? 0.8 : 0.75;
        
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return ProjectCard(project: project);
          },
        );
      },
    );
  }
}
