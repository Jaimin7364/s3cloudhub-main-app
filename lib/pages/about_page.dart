import 'dart:async';
import 'package:flutter/material.dart';
import 'package:s3cloudhub/components/app_drawer.dart';
import '../components/header.dart';
import '../components/footer.dart';
import 'package:collection/collection.dart'; // for mapIndexed

/// ---------------------------------------------------------------------------
/// AboutPage 2.0 – Highly‑interactive version for S3CloudHub
/// ---------------------------------------------------------------------------
/// • Animated gradient background (12‑s loop).
/// • Gradient‑filled headlines that subtly shimmer.
/// • Typewriter reveal for the intro paragraph.
/// • Emoji bullets replaced with proper icons & slide‑in animation.
/// • Animated counters (years in business, projects delivered, etc.).
/// • Parallax hero badge behind headline (optional asset).
/// • CTA banner retains previous style.
/// ---------------------------------------------------------------------------
class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bgCtrl;
  late final Animation<Color?> _c1;
  late final Animation<Color?> _c2;

  /// Typewriter intro controller
  late final Stream<String> _typedIntro$;

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 12))
      ..repeat(reverse: true);
    _c1 = ColorTween(begin: Colors.blue.shade900, end: Colors.deepPurple)
        .animate(_bgCtrl);
    _c2 = ColorTween(begin: Colors.indigo, end: Colors.pink.shade200)
        .animate(_bgCtrl);

    const introText =
        'S3CloudHub is a technology studio focused on empowering businesses, startups and creators through cloud computing, DevOps automation and full‑stack software engineering. From idea to production, we craft scalable solutions that accelerate innovation and strengthen digital resilience.';

    _typedIntro$ = _typewriter(introText, charDelay: 20);
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: AnimatedBuilder(
        animation: _bgCtrl,
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
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
                  children: [
                    // Parallax badge behind headline (simple translucent circle)
                    Stack(
                      children: [
                        Positioned(
                          left: -60,
                          top: -20,
                          child: AnimatedBuilder(
                            animation: _bgCtrl,
                            builder: (context, _) => Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _c2.value!.withOpacity(.25),
                              ),
                            ),
                          ),
                        ),
                        _AnimatedSection(
                          delay: 0,
                          child: _gradientHeadline('About S3CloudHub'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Typewriter paragraph ------------------------------------------------
                    StreamBuilder<String>(
                      stream: _typedIntro$,
                      builder: (context, snapshot) => _para(snapshot.data ?? ''),
                    ),
                    const SizedBox(height: 32),
                    _AnimatedSection(
                      delay: 400,
                      child: _gradientSubhead(Icons.rocket_launch, 'Our Mission'),
                    ),
                    _AnimatedSection(
                      delay: 600,
                      child: _para(
                        'To democratise enterprise‑grade cloud and DevOps practices so that organisations of any size can deliver value to their users **faster, safer and more economically.**',
                      ),
                    ),
                    const SizedBox(height: 24),
                    _AnimatedSection(
                      delay: 900,
                      child: _gradientSubhead(Icons.star, 'Our Vision'),
                    ),
                    _AnimatedSection(
                      delay: 1100,
                      child: _para(
                        'A world where every brilliant idea can reach global scale without worrying about infrastructure complexity.',
                      ),
                    ),
                    const SizedBox(height: 24),
                    _AnimatedSection(
                      delay: 1400,
                      child: _gradientSubhead(Icons.favorite, 'Core Values'),
                    ),
                    _AnimatedSection(
                      delay: 1600,
                      child: _valuesList(),
                    ),
                    const SizedBox(height: 24),
                    _AnimatedSection(
                      delay: 2000,
                      child: _gradientSubhead(Icons.handyman, 'Preferred Tech Stack'),
                    ),
                    _AnimatedSection(
                      delay: 2200,
                      child: _techChips([
                        'AWS / Azure / GCP',
                        'Docker & Kubernetes',
                        'Terraform & Pulumi',
                        'GitHub Actions / Azure Pipelines',
                        'Node • Flutter • React',
                        'Python • Go • Java',
                      ]),
                    ),
                    const SizedBox(height: 40),
                    _AnimatedSection(
                      delay: 2600,
                      child: _statsRow(),
                    ),
                    const SizedBox(height: 60),
                    _AnimatedSection(
                      delay: 3000,
                      child: _ctaBanner(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }

  // -------------------------------------------------------------------------
  // Text helpers
  // -------------------------------------------------------------------------
  Widget _gradientHeadline(String text) => ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Color(0xFFFFD760), Color(0xFFFA709A)],
        ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
        blendMode: BlendMode.srcIn,
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );

  Widget _gradientSubhead(IconData icon, String text) => Row(
        children: [
          Icon(icon, color: Colors.amberAccent, size: 28),
          const SizedBox(width: 8),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF86FDE8), Color(0xFF5CA6FF)],
            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
            blendMode: BlendMode.srcIn,
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      );

  Widget _para(String text) => SelectableText(
        text,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: Colors.white.withOpacity(.9), height: 1.55),
      );

  Widget _valuesList() {
    const vals = [
      'Customer Obsession – your success is our metric.',
      'Automation First – repetitive work belongs to code, not people.',
      'Continuous Learning – tech evolves, so do we.',
      'Transparency – clear pricing, clear communication, clear outcomes.',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: vals.mapIndexed((i, v) {
        return _AnimatedSection(
          delay: 1600 + i * 150,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Icon(Icons.check_circle, color: Colors.lightGreenAccent, size: 20),
              ),
              const SizedBox(width: 8),
              Expanded(child: _para(v)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _techChips(List<String> tech) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: tech
            .map(
              (t) => Chip(
                label: Text(t),
                backgroundColor: Colors.white.withOpacity(0.15),
                labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
            .toList(),
      );

  Widget _statsRow() {
    final stats = [
      ('5+', 'Years in business'),
      ('60+', 'Projects delivered'),
      ('15', 'Cloud experts'),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: stats.map((s) => _AnimatedCounter(value: s.$1, label: s.$2)).toList(),
    );
  }

  Widget _ctaBanner(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFFFFA17F), Color(0xFF00223E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Text(
              'Ready to elevate your cloud journey?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Get in touch'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pushNamed('/contact'),
            ),
          ],
        ),
      );

  // -------------------------------------------------------------------------
  // Utility: typewriter stream
  // -------------------------------------------------------------------------
  Stream<String> _typewriter(String fullText, {int charDelay = 30}) async* {
    final buffer = StringBuffer();
    for (var rune in fullText.runes) {
      buffer.write(String.fromCharCode(rune));
      yield buffer.toString();
      await Future.delayed(Duration(milliseconds: charDelay));
    }
  }
}

// ===========================================================================
// Animated counter widget
// ===========================================================================
class _AnimatedCounter extends StatefulWidget {
  final String value;
  final String label;
  const _AnimatedCounter({required this.value, required this.label});

  @override
  State<_AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<_AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
        WidgetsBinding.instance.addPostFrameCallback((_) {
      _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _anim,
      child: Column(
        children: [
          Text(
            widget.value,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.label,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Animated section (slide + fade on appear)
// ===========================================================================
class _AnimatedSection extends StatefulWidget {
  final Widget child;
  final int delay; // in milliseconds
  const _AnimatedSection({required this.child, this.delay = 0});

  @override
  State<_AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<_AnimatedSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _offset = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

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
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _offset,
        child: widget.child,
      ),
    );
  }
}

