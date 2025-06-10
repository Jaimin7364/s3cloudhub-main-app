import 'package:flutter/material.dart';
import 'package:s3cloudhub/components/app_drawer.dart';
import '../components/header.dart';
import '../components/footer.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  static const List<Map<String, String>> services = [
    {
      'title': 'Web Development',
      'description':
          'Crafting modern, responsive websites with the latest tech stack.',
      'icon': 'web',
    },
    {
      'title': 'Mobile App Development',
      'description':
          'Native & cross‑platform apps to put your idea in every pocket.',
      'icon': 'smartphone',
    },
    {
      'title': 'UI / UX Design',
      'description':
          'Intuitive, beautiful interfaces that delight users and convert.',
      'icon': 'brush',
    },
    {
      'title': 'Content Writing',
      'description':
          'SEO‑friendly blogs, technical docs & marketing copy that clicks.',
      'icon': 'edit',
    },
    {
      'title': 'Logo & Branding',
      'description':
          'Strong visual identities that make your brand unforgettable.',
      'icon': 'palette',
    },
    {
      'title': 'Cloud Solutions',
      'description':
          'Scalable, secure cloud architectures and migrations.',
      'icon': 'cloud',
    },
    {
      'title': 'DevOps Automation',
      'description':
          'CI/CD pipelines & IaC that accelerate your release velocity.',
      'icon': 'build',
    },
    {
      'title': '24 × 7 Support',
      'description':
          'Always‑on monitoring & rapid response for mission‑critical systems.',
      'icon': 'support_agent',
    },
    {
      'title': 'Cybersecurity',
      'description':
          'Pen‑testing, hardening & continuous threat monitoring.',
      'icon': 'shield',
    },
    {
      'title': 'SEO Optimization',
      'description':
          'Data‑driven strategies to boost ranking & organic traffic.',
      'icon': 'trending_up',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFDAE2F8),
              Color(0xFFD6A4A4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Header(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Our Services',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: services.map((service) => ServiceCard(
                      title: service['title']!,
                      description: service['description']!,
                      icon: getIcon(service['icon']!),
                    )).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }

  static IconData getIcon(String iconName) {
    switch (iconName) {
      case 'cloud':
        return Icons.cloud;
      case 'build':
        return Icons.build;
      case 'web':
        return Icons.web;
      case 'smartphone':
        return Icons.smartphone;
      case 'brush':
        return Icons.brush;
      case 'edit':
        return Icons.edit;
      case 'palette':
        return Icons.palette;
      case 'support_agent':
        return Icons.support_agent;
      case 'shield':
        return Icons.shield;
      case 'trending_up':
        return Icons.trending_up;
      default:
        return Icons.miscellaneous_services;
    }
  }
}


class ServiceCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;

  const ServiceCard({super.key, 
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  State<ServiceCard> createState() => ServiceCardState();
}

class ServiceCardState extends State<ServiceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _contentOffset;
  late Animation<Offset> _descOffset;
  bool _hovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _contentOffset = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _descOffset = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  void _setHover(bool hover) {
    setState(() => _hovering = hover);
    if (hover) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double width = 320;
    const double height = 260;

    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: GestureDetector(
        onTap: () => _setHover(!_hovering),
        child: Container(
          width: width,
          height: height,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SlideTransition(
                position: _contentOffset,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.icon,
                      size: 80,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SlideTransition(
                position: _descOffset,
                child: Container(
                  width: width,
                  height: height,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(66, 133, 197, 1),
                        Color.fromRGBO(96, 122, 193, 1),
                        Color.fromRGBO(92, 123, 194, 1),
                        Color.fromRGBO(100, 121, 193, 1),
                        Color.fromRGBO(115, 116, 191, 1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}