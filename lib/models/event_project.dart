class EventProject {
  final String id;
  final String title;
  final String description;
  final double progress;
  final DateTime createdAt;
  final DateTime? dueDate;
  final List<String> linkedTimelineIds;
  final ProjectStatus status;
  final List<String> tags;
  final String? priority;
  final Map<String, dynamic>? metadata;

  const EventProject({
    required this.id,
    required this.title,
    this.description = '',
    this.progress = 0.0,
    required this.createdAt,
    this.dueDate,
    this.linkedTimelineIds = const [],
    this.status = ProjectStatus.backlog,
    this.tags = const [],
    this.priority,
    this.metadata,
  });

  EventProject copyWith({
    String? id,
    String? title,
    String? description,
    double? progress,
    DateTime? createdAt,
    DateTime? dueDate,
    List<String>? linkedTimelineIds,
    ProjectStatus? status,
    List<String>? tags,
    String? priority,
    Map<String, dynamic>? metadata,
  }) {
    return EventProject(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      linkedTimelineIds: linkedTimelineIds ?? this.linkedTimelineIds,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      priority: priority ?? this.priority,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'progress': progress,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'linkedTimelineIds': linkedTimelineIds,
      'status': status.name,
      'tags': tags,
      'priority': priority,
      'metadata': metadata,
    };
  }

  factory EventProject.fromJson(Map<String, dynamic> json) {
    return EventProject(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      linkedTimelineIds: List<String>.from(json['linkedTimelineIds'] ?? []),
      status: ProjectStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ProjectStatus.backlog,
      ),
      tags: List<String>.from(json['tags'] ?? []),
      priority: json['priority'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventProject && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

enum ProjectStatus {
  backlog('Backlog'),
  inProgress('In Progress'),
  completed('Completed'),
  onHold('On Hold'),
  cancelled('Cancelled'),
  life('Life');

  const ProjectStatus(this.displayName);
  final String displayName;
}