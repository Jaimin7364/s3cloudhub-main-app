import 'package:flutter/material.dart';

class FrameAnimationWidget extends StatelessWidget {
  const FrameAnimationWidget({super.key});

  final List<Map<String, String>> cardData = const [
    {
      "image":
          "https://res.cloudinary.com/dfj4u4btd/image/upload/v1748846658/nhdguv1bebtfnudj8lgy.png",
      "description":
          "Persuasive web designs contribute to lead conversion and traffic growth.",
    },
    {
      "image":
          "https://res.cloudinary.com/dfj4u4btd/image/upload/v1748846658/yye1g04xmst8bo0xsd9b.png",
      "description":
          "We provide cost-effective custom web development services.",
    },
    {
      "image":
          "https://res.cloudinary.com/dfj4u4btd/image/upload/v1748846658/f5hqkzx4zup4f6jti86w.png",
      "description":
          "Custom e-commerce websites with excellent APIs and design.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      alignment: WrapAlignment.center,
      children: cardData
          .map((data) => DrawerCard(
                imageUrl: data['image']!,
                description: data['description']!,
              ))
          .toList(),
    );
  }
}

class DrawerCard extends StatefulWidget {
  final String imageUrl;
  final String description;

  const DrawerCard({
    super.key,
    required this.imageUrl,
    required this.description,
  });

  @override
  State<DrawerCard> createState() => _DrawerCardState();
}

class _DrawerCardState extends State<DrawerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _imageOffset;
  late Animation<Offset> _textOffset;

  bool _hovering = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _imageOffset = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    _textOffset = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
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
            children: [
              // Image sliding out
              SlideTransition(
                position: _imageOffset,
                child: Image.network(
                  widget.imageUrl,
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                ),
              ),

              // Text coming in with gradient background
                SlideTransition(
                position: _textOffset,
                child: Container(
                  width: width,
                  height: height,
                  decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                    Color.fromRGBO(66, 133, 197, 1),   // steel-blue
                    Color.fromRGBO(96, 122, 193, 1),   // glaucous
                    Color.fromRGBO(92, 123, 194, 1),   // glaucous-2
                    Color.fromRGBO(100, 121, 193, 1),  // glaucous-3
                    Color.fromRGBO(115, 116, 191, 1),  // glaucous-4
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    widget.description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Roboto',
                      height: 1.4,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
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
