import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  final String id;
  final String title;
  final String company;
  final String location;
  final String salary;
  final String experience;
  final String category;
  final DateTime createdAt;

  const JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.experience,
    required this.category,
    required this.createdAt,
  });

  factory JobModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return JobModel(
      id: doc.id,
      title: (data['title'] ?? '') as String,
      company: (data['company'] ?? '') as String,
      location: (data['location'] ?? '') as String,
      salary: (data['salary'] ?? '') as String,
      experience: (data['experience'] ?? '') as String,
      category: (data['category'] ?? 'All') as String,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
