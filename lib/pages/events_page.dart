import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prisma_note/models/event_project.dart';
import 'package:prisma_note/widgets/project_card.dart';

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Events & Projects',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            
            // Tab Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: Colors.black,
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
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // In Progress
                  ProjectGrid(
                    projects: _getFilteredProjects(ProjectStatus.inProgress),
                  ),
                  
                  // Backlog
                  ProjectGrid(
                    projects: _getFilteredProjects(ProjectStatus.backlog),
                  ),
                  
                  // Projects
                  ProjectGrid(
                    projects: _getFilteredProjects(ProjectStatus.onHold),
                  ),
                  
                  // Life
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
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No projects here',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add some projects to get started',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[500],
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