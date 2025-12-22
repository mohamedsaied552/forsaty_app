class JobModel {
  final String id;
  final String employerId;
  final String title;
  final String description;
  final String location;
  final String? photoUrl;
  final DateTime createdAt;

  JobModel({
    required this.id,
    required this.employerId,
    required this.title,
    required this.description,
    required this.location,
    this.photoUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'employerId': employerId,
      'title': title,
      'description': description,
      'location': location,
      'photoUrl': photoUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory JobModel.fromMap(Map<String, dynamic> map, String docId) {
    return JobModel(
      id: docId,
      employerId: map['employerId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      photoUrl: map['photoUrl'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
    );
  }
}