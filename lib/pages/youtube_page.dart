// import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:s3cloudhub/components/app_drawer.dart';
import '../components/header.dart';
import '../components/footer.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage>
    with SingleTickerProviderStateMixin {
  // Background animation controller
  late final AnimationController _bg;
  late final Animation<Color?> _c1;
  late final Animation<Color?> _c2;

  // Playlist data (replace with your own)
  final List<Map<String, String>> _courses = const [
    {
      'title': 'AWS Certified SysOps Administrator Course',
      'thumbnailUrl': 'https://i.ytimg.com/vi/SXg_etVHZgk/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLA4plma_INAuHoU7CX0Nxuth9iuoQ',
      'videoUrl': 'https://youtube.com/playlist?list=PL_OdF9Z6GmVZJB7lnQl_4wB9nVl9dLHtN&feature=shared',
    },
    {
      'title': 'Terraform Full Course for Beginners',
      'thumbnailUrl': 'https://i.ytimg.com/vi/8CGZjYoLWlc/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLBrBT3qhrWP-W4U7hzrebcS5xlzIA',
      'videoUrl': 'https://www.youtube.com/playlist?list=PL_OdF9Z6GmVayanQ4cjISqY_UkrOcZtr1',
    },
    {
      'title': 'aws tutorial for beginners | AWS Full Course',
      'thumbnailUrl': 'https://i.ytimg.com/vi/1BYGZSl2ZsI/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLC-QmxikNXq06Jdx8-92ce8lawSsQ',
      'videoUrl': 'https://www.youtube.com/playlist?list=PL_OdF9Z6GmVYWYd4Pn-UMEsg3XyjWv0Mf',
    },
  ];

  @override
  void initState() {
    super.initState();
    _bg = AnimationController(vsync: this, duration: const Duration(seconds: 10))
      ..repeat(reverse: true);

    _c1 = ColorTween(begin: Colors.blue.shade800, end: Colors.deepPurple)
        .animate(_bg);
    _c2 = ColorTween(begin: Colors.indigo, end: Colors.pink.shade200).animate(_bg);
  }

  @override
  void dispose() {
    _bg.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: AnimatedBuilder(
        animation: _bg,
        builder: (context, child) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_c1.value ?? Colors.blue, _c2.value ?? Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: child,
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Header(),
              const SizedBox(height: 16),
              Text(
                'Courses on YouTube',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 900
                        ? 3
                        : constraints.maxWidth > 600
                            ? 2
                            : 1;
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 16 / 14, // Increased height for new design
                      ),
                      itemCount: _courses.length,
                      itemBuilder: (context, i) => _StaggeredCard(
                        delay: i * 100,
                        child: YouTubeVideoCard(
                          title: _courses[i]['title']!,
                          thumbnailUrl: _courses[i]['thumbnailUrl']!,
                          videoUrl: _courses[i]['videoUrl']!,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Bounce-in wrapper for staggered appearance
// ────────────────────────────────────────────────────────────────────────────
class _StaggeredCard extends StatefulWidget {
  final int delay; // ms
  final Widget child;
  const _StaggeredCard({required this.delay, required this.child});

  @override
  State<_StaggeredCard> createState() => _StaggeredCardState();
}

class _StaggeredCardState extends State<_StaggeredCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(scale: _scale, child: widget.child);
}

// ────────────────────────────────────────────────────────────────────────────
// CARD COMPONENT  (class name retained!) - FIXED OVERFLOW ISSUE
// ────────────────────────────────────────────────────────────────────────────
class YouTubeVideoCard extends StatefulWidget {
  final String title;
  final String thumbnailUrl;
  final String videoUrl;

  const YouTubeVideoCard({
    super.key,
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
  });

  @override
  State<YouTubeVideoCard> createState() => _YouTubeVideoCardState();
}

class _YouTubeVideoCardState extends State<YouTubeVideoCard>
    with SingleTickerProviderStateMixin {
  bool _hover = false;

  // Opens video / playlist in external app
  Future<void> _open() async {
    final uri = Uri.parse(widget.videoUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open YouTube')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: _open,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: _hover ? 1.05 : 1.0,
          curve: Curves.easeOut,
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Banner-style thumbnail with overlay ------------------------
                Expanded(
                  flex: 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade600, Colors.purple.shade600],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.play_circle_filled, 
                                       size: 60, 
                                       color: Colors.white),
                          ),
                        ),
                      ),
                      // Gradient overlay for better text visibility
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content section --------------------------------------------
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title with 100 character limit
                        Expanded(
                          child: Text(
                            widget.title.length > 100 
                                ? '${widget.title.substring(0, 100)}...'
                                : widget.title,
                            style: const TextStyle(
                              fontSize: 20, // Large title text
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              height: 1.2,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // View Course Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _open,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'View Course',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}