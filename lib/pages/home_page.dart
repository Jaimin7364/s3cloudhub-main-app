import 'package:flutter/material.dart';
import 'package:s3cloudhub/components/Frame_Animation.dart';
import 'package:s3cloudhub/components/Home_customcard.dart';
import 'package:s3cloudhub/components/ServicesSection.dart';
import 'package:s3cloudhub/pages/services_page.dart';

import '../components/header.dart';
import '../components/footer.dart';
import '../components/app_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'title': 'Welcome to S3CloudHub',
      'subtitle': 'Innovative Cloud & DevOps Solutions',
      'image':
          'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=800&q=60',
    },
    {
      'title': 'Empowering Startups',
      'subtitle': 'Building Scalable Software',
      'image':
          'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=800&q=60',
    },
    {
      'title': 'Your DevOps Partner',
      'subtitle': 'Automate & Accelerate',
      'image':
          'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=800&q=60',
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), _autoSlide);
  }

  void _autoSlide() {
    if (!mounted) return;
    int nextPage = (_currentPage + 1) % _slides.length;
    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    setState(() => _currentPage = nextPage);
    Future.delayed(const Duration(seconds: 4), _autoSlide);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onDotTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    setState(() => _currentPage = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: null,
      drawer: const AppDrawer(), // ✅ Added Drawer Here
      body: SafeArea(
        child: Column(
          children: [
            const Header(), // ✅ Now safe from overlap
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 500,
                        child: Stack(
                          children: [
                            PageView.builder(
                    controller: _pageController,
                    itemCount: _slides.length,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemBuilder: (context, index) {
                      final slide = _slides[index];
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(slide['image']!, fit: BoxFit.cover),
                          Container(color: Colors.black.withOpacity(0.4)),
                          Positioned(
                            left: 20,
                            bottom: 40,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  slide['title']!,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 5,
                                        color: Colors.black54,
                                        offset: Offset(2, 2),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  slide['subtitle']!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _slides.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _onDotTapped(entry.key),
                          child: Container(
                            width: _currentPage == entry.key ? 12.0 : 8.0,
                            height: _currentPage == entry.key ? 12.0 : 8.0,
                            margin: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 4.0,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == entry.key
                                  ? theme.primaryColor
                                  : Colors.grey[400],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _AnimatedButton(
                  label: 'Our Services',
                  icon: Icons.build_circle,
                  onPressed: () {
                    Navigator.pushNamed(context, '/services');
                  },
                ),
                _AnimatedButton(
                  label: 'Watch Videos',
                  icon: Icons.play_circle_fill,
                  onPressed: () {
                    Navigator.pushNamed(context, '/youtube');
                  },
                ),
                _AnimatedButton(
                  label: 'Contact Us',
                  icon: Icons.contact_mail,
                  onPressed: () {
                    Navigator.pushNamed(context, '/contact');
                  },
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: FrameAnimationWidget(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: MediaQuery.of(context).size.width >= 800 ? 24.0 : 0.0,
              ),
              child: const HomeCustomCard(),
            ),
            ServicesSection(
                onSeeAllPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ServicesPage()),
                  );
                },
              ),
            const SizedBox(height: 50),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About S3CloudHub',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'We provide cutting-edge cloud, DevOps, and development services that help startups and businesses scale their technology effortlessly.',
                    style: TextStyle(fontSize: 16, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
        ),
       ),
      ],
      ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}

class _AnimatedButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _AnimatedButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.05,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: child,
        ),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 6,
          ),
          icon: Icon(widget.icon, size: 26),
          label: Text(widget.label, style: const TextStyle(fontSize: 18)),
          onPressed: null,
        ),
      ),
    );
  }
}