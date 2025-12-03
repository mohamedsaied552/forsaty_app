class User {
  final String id;
  final String email;
  final String role; // 'Worker', 'Employer', or 'Admin'
  final String name;
  final String phone;
  final String bio;
  final List<String> skills;

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.name,
    required this.phone,
    this.bio = '',
    this.skills = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'email': email,
      'role': role,
      'name': name,
      'phone': phone,
      'bio': bio,
      'skills': skills,
    };
  }

  factory User.fromMap(Map<String, dynamic> map, String docId) {
    return User(
      id: map['uid'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'Worker',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      bio: map['bio'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
    );
  }
}