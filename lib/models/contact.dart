class Contact {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? voicePrintId;
  final List<String> relatedEventIds;
  final DateTime createdAt;
  final DateTime? lastContact;
  final List<String> tags;
  final String? notes;
  final ContactType type;
  final Map<String, dynamic>? metadata;

  const Contact({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.voicePrintId,
    this.relatedEventIds = const [],
    required this.createdAt,
    this.lastContact,
    this.tags = const [],
    this.notes,
    this.type = ContactType.personal,
    this.metadata,
  });

  Contact copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? voicePrintId,
    List<String>? relatedEventIds,
    DateTime? createdAt,
    DateTime? lastContact,
    List<String>? tags,
    String? notes,
    ContactType? type,
    Map<String, dynamic>? metadata,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      voicePrintId: voicePrintId ?? this.voicePrintId,
      relatedEventIds: relatedEventIds ?? this.relatedEventIds,
      createdAt: createdAt ?? this.createdAt,
      lastContact: lastContact ?? this.lastContact,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      type: type ?? this.type,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'voicePrintId': voicePrintId,
      'relatedEventIds': relatedEventIds,
      'createdAt': createdAt.toIso8601String(),
      'lastContact': lastContact?.toIso8601String(),
      'tags': tags,
      'notes': notes,
      'type': type.name,
      'metadata': metadata,
    };
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      voicePrintId: json['voicePrintId'] as String?,
      relatedEventIds: List<String>.from(json['relatedEventIds'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastContact: json['lastContact'] == null
          ? null
          : DateTime.parse(json['lastContact'] as String),
      tags: List<String>.from(json['tags'] ?? []),
      notes: json['notes'] as String?,
      type: ContactType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ContactType.personal,
      ),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Contact && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

enum ContactType {
  personal('Personal'),
  work('Work'),
  family('Family'),
  friend('Friend'),
  client('Client'),
  service('Service Provider'),
  other('Other');

  const ContactType(this.displayName);
  final String displayName;
}