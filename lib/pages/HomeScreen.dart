// lib/pages/HomeScreen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forsaty/pages/Employer_Profile_Screen.dart';

// NOTE: You imported JobPostingScreen.dart but you are using CreatePostScreen.
// Make sure CreatePostScreen exists in that file.
import 'package:forsaty/pages/JobPostingScreen.dart';
import 'package:forsaty/pages/Worker_Profile_Screen.dart';

import '../logic/home/home_bloc.dart';
import '../logic/home/home_event.dart';
import '../logic/home/home_state.dart';
import '../models/job_model.dart';
import '../models/post_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _categories = [
    'All',
    'Mobile Developer',
    'Designer',
    'Marketing',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(const HomeStarted()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  int _tabIndex = 0;

  // Colors
  static const _cDark = Color(0xFF1B384A);
  static const _cTextGrey = Color(0xFF596574);
  static const _cLightGrey = Color(0xFF838383);
  static const _cBorder = Color(0xFFE5E5E7);
  static const _cSalaryBg = Color(0xFFF2F9FF);
  static const _cPurple = Color(0xFF736CFB);
  static const _cLikeBlue = Color(0xFF0A77FF);

  // -------------------- STATIC LOCAL JOBS --------------------
  // This list is LOCAL فقط (no database).
  // If your JobModel constructor/fields differ, adjust here to match your model.
  final List<JobModel> _localJobs = [
    JobModel(
      id: '1',
      title: 'Flutter Developer',
      company: 'Microsoft Corporation',
      location: 'Cairo, Egypt',
      salary: r'$1000 - $2000 / month',
      experience: '1-2 years',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      category: 'Mobile Developer',
    ),
    JobModel(
      id: '2',
      title: 'Mobile Developer',
      company: 'Figma',
      location: 'Remote',
      salary: r'$800 - $1500 / month',
      experience: '0-1 years',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      category: 'Mobile Developer',
    ),
    JobModel(
      id: '3',
      title: 'Designer',
      company: 'Apple',
      location: 'Dubai, UAE',
      salary: r'$1200 - $2200 / month',
      experience: '2-3 years',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      category: ' Designer',
    ),
    JobModel(
      id: '4',
      title: 'Marketing',
      company: 'Huawei',
      location: 'Riyadh, KSA',
      salary: r'$1500 - $2500 / month',
      experience: '1-3 years',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      category: ' Marketing',
    ),
  ];
  // -----------------------------------------------------------

  TextStyle _t({
    double size = 16,
    FontWeight weight = FontWeight.w400,
    Color color = Colors.black,
    double height = 1.0,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: 'JosefinSans',
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  List<JobModel> _filteredJobs(String category) {
    if (category == 'All') return _localJobs;

    // Simple filter: match in title
    return _localJobs
        .where((j) => j.title.toLowerCase().contains(category.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_3_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmployerProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: _BottomTabBar(
        currentIndex: _tabIndex,
        onChanged: (i) => setState(() => _tabIndex = i),
      ),
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final jobs = _filteredJobs(state.category);

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 12),

                // Categories chips
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: HomePage._categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      final label = HomePage._categories[i];
                      final selected = label == state.category;
                      return _PillChip(
                        label: label,
                        selected: selected,
                        onTap: () => context.read<HomeBloc>().add(
                          HomeCategoryChanged(label),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 36),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _HeaderRow(
                        title: 'Top Companies Hiring',
                        action: 'View all',
                        text: _t,
                      ),
                      const SizedBox(height: 32),

                      // Jobs are LOCAL => no loading here
                      SizedBox(
                        height: 234,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: jobs.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 16),
                          itemBuilder: (context, i) => _JobCard(
                            job: jobs[i],
                            text: _t,
                            cTextGrey: _cTextGrey,
                            cLightGrey: _cLightGrey,
                            cSalaryBg: _cSalaryBg,
                            cPurple: _cPurple,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Recent Posts',
                              style: _t(size: 22, weight: FontWeight.w600),
                            ),
                          ),
                          _SortButton(
                            text: _t,
                            border: _cBorder,
                            textGrey: _cTextGrey,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Posts from Bloc (Firebase or whatever your HomeBloc uses)
                      if (state.status == HomeStatus.failure)
                        Text(
                          state.error ?? 'Error',
                          style: _t(color: Colors.red),
                        )
                      else if (state.status == HomeStatus.loading &&
                          state.posts.isEmpty)
                        const Center(child: CircularProgressIndicator())
                      else
                        Column(
                          children: state.posts
                              .map(
                                (p) => Padding(
                                  padding: const EdgeInsets.only(bottom: 32),
                                  child: _PostCard(
                                    post: p,
                                    text: _t,
                                    cTextGrey: _cTextGrey,
                                    cBorder: _cBorder,
                                    cDark: _cDark,
                                    cLikeBlue: _cLikeBlue,
                                  ),
                                ),
                              )
                              .toList(growable: false),
                        ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/* ---------- Small UI Widgets ---------- */

class _HeaderRow extends StatelessWidget {
  final String title;
  final String action;
  final TextStyle Function({
    double size,
    FontWeight weight,
    Color color,
    double height,
    double? letterSpacing,
  })
  text;

  const _HeaderRow({
    required this.title,
    required this.action,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: text(size: 22, weight: FontWeight.w600)),
        ),
        Text(
          action,
          style: text(
            size: 20,
            weight: FontWeight.w600,
            color: const Color(0xFF4F4F4F),
            height: 1.25,
          ),
        ),
      ],
    );
  }
}

class _SortButton extends StatelessWidget {
  final TextStyle Function({
    double size,
    FontWeight weight,
    Color color,
    double height,
    double? letterSpacing,
  })
  text;
  final Color border;
  final Color textGrey;

  const _SortButton({
    required this.text,
    required this.border,
    required this.textGrey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(128),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Sort',
            style: text(size: 16, weight: FontWeight.w600, color: textGrey),
          ),
          const SizedBox(width: 10),
          Icon(Icons.swap_vert, size: 22, color: textGrey),
        ],
      ),
    );
  }
}

class _PillChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PillChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  static const _cDark = Color(0xFF1B384A);
  static const _cChipBg = Color(0xFFECF4FC);
  static const _cChipBorder = Color(0xFFB2D5FF);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(128),
      onTap: onTap,
      child: Container(
        height: selected ? 44 : 42,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? _cDark : _cChipBg,
          border: selected ? null : Border.all(color: _cChipBorder),
          borderRadius: BorderRadius.circular(128),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'JosefinSans',
            fontSize: selected ? 16 : 15,
            fontWeight: FontWeight.w600,
            height: selected ? 24 / 16 : 22 / 15,
            letterSpacing: selected ? -0.01 : null,
            color: selected ? Colors.white : _cDark,
          ),
        ),
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final JobModel job;
  final TextStyle Function({
    double size,
    FontWeight weight,
    Color color,
    double height,
    double? letterSpacing,
  })
  text;
  final Color cTextGrey;
  final Color cLightGrey;
  final Color cSalaryBg;
  final Color cPurple;

  const _JobCard({
    required this.job,
    required this.text,
    required this.cTextGrey,
    required this.cLightGrey,
    required this.cSalaryBg,
    required this.cPurple,
  });

  String _timeAgo(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 60) return '${diff.inMinutes} mins ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 364,
      height: 234,
      padding: const EdgeInsets.symmetric(vertical: 21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            offset: Offset(0, 4),
            color: Color(0x40000000),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.business, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: text(
                            size: 20,
                            weight: FontWeight.w600,
                            height: 25 / 20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          job.company,
                          style: text(
                            size: 18,
                            color: cTextGrey,
                            height: 26 / 18,
                            letterSpacing: -0.01,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.bookmark_border,
                    color: Color(0xFF9A9A9A),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: CustomPaint(
              painter: _DashedLinePainter(color: cLightGrey),
              child: const SizedBox(height: 1, width: double.infinity),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 27),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Color(0xFF8DBAEF),
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    job.location,
                    style: text(
                      size: 16,
                      weight: FontWeight.w600,
                      color: cTextGrey,
                      height: 24 / 16,
                      letterSpacing: -0.01,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 40,
              width: 217,
              padding: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: cSalaryBg,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(49.5),
                  bottomRight: Radius.circular(49.5),
                ),
              ),
              alignment: Alignment.centerRight,
              child: Text(
                job.salary,
                style: text(
                  size: 16,
                  weight: FontWeight.w600,
                  color: cPurple,
                  height: 24 / 16,
                  letterSpacing: -0.01,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 58),
                    child: Text(
                      job.experience,
                      style: text(
                        size: 16,
                        weight: FontWeight.w600,
                        color: cLightGrey,
                        height: 24 / 16,
                        letterSpacing: -0.01,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      color: Color(0xFF9A9A9A),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _timeAgo(job.createdAt),
                      style: text(
                        size: 14,
                        color: cTextGrey,
                        height: 20 / 14,
                        letterSpacing: -0.1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PostCard extends StatelessWidget {
  final PostModel post;
  final TextStyle Function({
    double size,
    FontWeight weight,
    Color color,
    double height,
    double? letterSpacing,
  })
  text;
  final Color cTextGrey;
  final Color cBorder;
  final Color cDark;
  final Color cLikeBlue;

  const _PostCard({
    required this.post,
    required this.text,
    required this.cTextGrey,
    required this.cBorder,
    required this.cDark,
    required this.cLikeBlue,
  });

  String _timeAgo(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 60) return '${diff.inMinutes} mins ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 396,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: cBorder, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(128),
                        ),
                        child: const Icon(Icons.person, size: 34),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: SizedBox(
                          height: 77,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.name,
                                style: text(
                                  size: 20,
                                  weight: FontWeight.w600,
                                  height: 25 / 20,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                post.title,
                                style: text(
                                  size: 16,
                                  weight: FontWeight.w600,
                                  color: cTextGrey,
                                  height: 24 / 16,
                                  letterSpacing: -0.01,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.more_horiz,
                          color: Color(0xFF9A9A9A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: cDark,
                        borderRadius: BorderRadius.circular(128),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_box_outlined,
                            size: 18,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Apply',
                            style: text(
                              size: 14,
                              weight: FontWeight.w600,
                              color: Colors.white,
                              height: 20 / 14,
                              letterSpacing: -0.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Post body
                  Text(
                    post.description,
                    style: text(
                      size: 18,
                      color: cTextGrey,
                      height: 26 / 18,
                      letterSpacing: -0.01,
                    ),
                  ),

                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Read More',
                      style: text(
                        size: 18,
                        weight: FontWeight.w600,
                        height: 28 / 18,
                        letterSpacing: -0.01,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.thumb_up, size: 20, color: cLikeBlue),
                            const SizedBox(width: 10),
                            Text(
                              'Like',
                              style: text(
                                size: 16,
                                color: cLikeBlue,
                                height: 24 / 16,
                                letterSpacing: -0.01,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            size: 20,
                            color: Color(0xFF9A9A9A),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _timeAgo(post.createdAt),
                            style: text(
                              size: 16,
                              color: cTextGrey,
                              height: 24 / 16,
                              letterSpacing: -0.01,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/* Bottom Bar */
class _BottomTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const _BottomTabBar({required this.currentIndex, required this.onChanged});

  static const _cTabBg = Color(0xFFFAFBFC);
  static const _cBorder = Color(0xFFE5E5E7);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: const BoxDecoration(
        color: _cTabBg,
        border: Border(top: BorderSide(color: _cBorder)),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      padding: const EdgeInsets.only(top: 7.25),
      child: Row(
        children: [
          _TabItem(
            label: 'Like',
            icon: Icons.favorite_border,
            selected: currentIndex == 0,
            onTap: () => onChanged(0),
          ),
          _TabItem(
            label: 'Message',
            icon: Icons.chat_bubble_outline,
            selected: currentIndex == 1,
            onTap: () => onChanged(1),
          ),
          _TabItem(
            label: 'Share',
            icon: Icons.share_outlined,
            selected: currentIndex == 2,
            onTap: () => onChanged(2),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: const Color(0xFF979AA0)),
            const SizedBox(height: 9.07),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'JosefinSans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 16 / 14,
                letterSpacing: 0.03,
                color: Color(0xFF979AA0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
