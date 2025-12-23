import 'package:flutter/material.dart';
import 'package:forsaty/pages/EditProfileScreen.dart';
import 'package:forsaty/pages/HomeScreen.dart';

class WorkerProfileScreen extends StatelessWidget {
  const WorkerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const  HomePage(),
                ),
              );
            },
          ),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            _ProfileHeader(),

            const SizedBox(height: 24),

            /// ABOUT
            _SectionTitle("About"),
            const Text(
              
              "Experienced web developer specializing in clean UI and scalable apps.",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            /// SKILLS
            _SectionTitle("Skills"),
            Wrap(
              spacing: 8,
              children: const [
                Chip(label: Text("Flutter")),
                Chip(label: Text("Firebase")),
                Chip(label: Text("UI/UX")),
              ],
            ),

            const SizedBox(height: 24),

            /// EXPERIENCE
            _SectionTitle("Experience"),
            _ExperienceItem(
              title: "Sr. Developer",
              company: "Power Web Design",
              period: "2021 - Present",
            ),
            _ExperienceItem(
              title: "Jr. Developer",
              company: "Urban Design",
              period: "2018 - 2021",
            ),

            const SizedBox(height: 24),

            /// CONTACT
            _SectionTitle("Contact"),
            _ContactRow(Icons.phone, "+20 123 456 789"),
            _ContactRow(Icons.email, "worker@email.com"),
          ],
        ),
      ),
    );
  }
}

/// ================== COMPONENTS ==================

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage("assets/profile.png"),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Andrew Michel",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                "Sr. Android Developer",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const EditProfileScreen(),
              ),
            );
          },
          child: const Text("Edit"),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ExperienceItem extends StatelessWidget {
  final String title;
  final String company;
  final String period;

  const _ExperienceItem({
    required this.title,
    required this.company,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.work),
      title: Text(title),
      subtitle: Text("$company • $period"),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
