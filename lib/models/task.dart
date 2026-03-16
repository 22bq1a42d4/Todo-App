class Task {
  String id;
  String title;
  String description;
  String priority;
  String label;
  bool isCompleted;
  DateTime createdAt;
  DateTime? completedAt;
  DateTime? deadline; // NEW: Added Deadline

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.priority = 'Low',
    this.label = 'Personal',
    this.isCompleted = false,
    required this.createdAt,
    this.completedAt,
    this.deadline, // NEW
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      priority: json['priority'] ?? 'Low',
      label: json['label'] ?? 'Personal',
      isCompleted: json['isCompleted'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'])
          : null, // NEW
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'label': label,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'deadline': deadline?.toIso8601String(), // NEW
    };
  }
}
