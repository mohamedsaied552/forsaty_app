class UserModel {
  final String id;
  final String email;
  final String role; // 'Worker', 'Employer', or 'Admin'
  final String name;
  final String phone;
  final String? password; 
  final String bio;
  final List<String> skills;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.name,
    required this.phone,
    this.password,
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
      if (password != null) 'password': password,
      'bio': bio,
      'skills': skills,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String docId) {
    return UserModel(
      id: map['uid'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'Worker',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      password: map['password'],
      bio: map['bio'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
    );
  }
}