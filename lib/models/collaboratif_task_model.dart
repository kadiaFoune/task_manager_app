class CollaboratifTask {
  final int id;
  final String title;
  final String? description;
  final bool completed;
  final int userId;

  CollaboratifTask({
    required this.id,
    required this.title,
    this.description,
    required this.completed,
    required this.userId,
  });

  factory CollaboratifTask.fromJson(Map<String, dynamic> json) {
    return CollaboratifTask(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? json['body'] ?? '',
      completed: json['completed'] ?? json['isCompleted'] ?? false,
      userId: json['userId'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
      'userId': userId,
    };
  }
}