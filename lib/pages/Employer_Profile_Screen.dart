import 'package:flutter/material.dart';

class EmployerProfileScreen extends StatelessWidget {
  const EmployerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Employer Profile"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.business, size: 40),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Power Web Company",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Cairo, Egypt",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(onPressed: () {}, child: const Text("Edit")),
              ],
            ),

            const SizedBox(height: 24),

            /// ABOUT
            const Text(
              "About Company",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "We are a leading company specializing in software solutions and digital services.",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            /// JOB POSTS
            const Text(
              "Posted Jobs",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _JobCard(),
            _JobCard(),
          ],
        ),
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: const Text("Flutter Developer"),
        subtitle: const Text("Cairo • Full Time"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}
