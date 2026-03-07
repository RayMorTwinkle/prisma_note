import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/event_project.dart';
import '../widgets/project_grid.dart';
import '../constants/app_colors.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<EventProject> _sampleProjects = [
    EventProject(
      id: '1',
      title: 'Prisma Note App Development',
      description: 'Building the core productivity app with Flutter',
      progress: 0.65,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      dueDate: DateTime.now().add(const Duration(days: 14)),
      status: ProjectStatus.inProgress,
      tags: ['development', 'flutter', 'productivity'],
      priority: 'high',
    ),
    EventProject(
      id: '2',
      title: 'Marketing Website Redesign',
      description: 'Complete overhaul of company marketing website',
      progress: 0.25,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      dueDate: DateTime.now().add(const Duration(days: 45)),
      status: ProjectStatus.backlog,
      tags: ['design', 'web', 'marketing'],
      priority: 'medium',
    ),
    EventProject(
      id: '3',
      title: 'Quarterly Team Review',
      description: 'Prepare Q4 performance reviews and planning',
      progress: 0.8,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      dueDate: DateTime.now().add(const Duration(days: 5)),
      status: ProjectStatus.inProgress,
      tags: ['management', 'hr', 'planning'],
      priority: 'high',
    ),
    EventProject(
      id: '4',
      title: 'Home Office Setup',
      description: 'Organize and optimize home office workspace',
      progress: 0.4,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      status: ProjectStatus.life,
      tags: ['personal', 'organization'],
      priority: 'low',
    ),
    EventProject(
      id: '5',
      title: 'JavaScript Course Completion',
      description: 'Complete advanced JavaScript online course',
      progress: 1.0,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      status: ProjectStatus.completed,
      tags: ['education', 'javascript', 'development'],
    ),
    EventProject(
      id: '6',
      title: 'Database Migration',
      description: 'Migrate legacy database to new cloud infrastructure',
      progress: 0.1,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      status: ProjectStatus.onHold,
      tags: ['infrastructure', 'database', 'cloud'],
      priority: 'high',
    ),
    EventProject(
      id: '7',
      title: 'Gym Membership',
      description: 'Join local gym and establish workout routine',
      progress: 0.3,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
      status: ProjectStatus.life,
      tags: ['health', 'fitness'],
      priority: 'medium',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<EventProject> _getFilteredProjects(ProjectStatus? status) {
    return _sampleProjects.where((project) {
      if (status == ProjectStatus.life) {
        return project.status == ProjectStatus.life;
      }
      return project.status == status;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Events & Projects',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.grey600,
                indicatorColor: AppColors.primary,
                indicatorWeight: 2,
                labelStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                unselectedLabelStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                tabs: const [
                  Tab(text: 'In Progress'),
                  Tab(text: 'Backlog'),
                  Tab(text: 'Projects'),
                  Tab(text: 'Life'),
                ],
              ),
            ),
            
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ProjectGrid(
                    projects: _getFilteredProjects(ProjectStatus.inProgress),
                  ),
                  
                  ProjectGrid(
                    projects: _getFilteredProjects(ProjectStatus.backlog),
                  ),
                  
                  ProjectGrid(
                    projects: _getFilteredProjects(ProjectStatus.onHold),
                  ),
                  
                  ProjectGrid(
                    projects: _getFilteredProjects(ProjectStatus.life),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
