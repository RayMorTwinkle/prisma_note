enum TimelineType {
  note,
  event,
  task,
  voiceMemo,
  meeting,
  reminder,
}

class TimelineItem {
  final String id;
  final DateTime timestamp;
  final String title;
  final String? summary;
  final TimelineType type;
  final List<String> participants;
  final List<String> generatedToDos;
  final bool isFavorite;
  final Map<String, dynamic>? metadata;

  const TimelineItem({
    required this.id,
    required this.timestamp,
    required this.title,
    this.summary,
    required this.type,
    this.participants = const [],
    this.generatedToDos = const [],
    this.isFavorite = false,
    this.metadata,
  });

  TimelineItem copyWith({
    String? id,
    DateTime? timestamp,
    String? title,
    String? summary,
    TimelineType? type,
    List<String>? participants,
    List<String>? generatedToDos,
    bool? isFavorite,
    Map<String, dynamic>? metadata,
  }) {
    return TimelineItem(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      type: type ?? this.type,
      participants: participants ?? this.participants,
      generatedToDos: generatedToDos ?? this.generatedToDos,
      isFavorite: isFavorite ?? this.isFavorite,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'title': title,
      'summary': summary,
      'type': type.name,
      'participants': participants,
      'generatedToDos': generatedToDos,
      'isFavorite': isFavorite,
      'metadata': metadata,
    };
  }

  factory TimelineItem.fromJson(Map<String, dynamic> json) {
    return TimelineItem(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      title: json['title'] as String,
      summary: json['summary'] as String?,
      type: TimelineType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TimelineType.note,
      ),
      participants: List<String>.from(json['participants'] ?? []),
      generatedToDos: List<String>.from(json['generatedToDos'] ?? []),
      isFavorite: json['isFavorite'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimelineItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}