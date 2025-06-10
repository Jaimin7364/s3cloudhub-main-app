import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Container(
      color: Colors.white,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Removed back button

          GestureDetector(
            onTap: () {
              // Navigate to home page only if not already on it
              if (ModalRoute.of(context)?.settings.name != '/') {
                Navigator.pushNamed(context, '/');
              }
            },
            child: Image.network(
              'https://res.cloudinary.com/dfj4u4btd/image/upload/v1747645732/untx2kq0npaikwelm7gj.jpg',
              height: 40,
            ),
          ),

          if (isMobile)
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            )
          else
            Row(
              children: [
                _buildNavItem(context, 'Home', '/'),
                _buildNavItem(context, 'Services', '/services'),
                _buildNavItem(context, 'courses', '/courses'),
                _buildNavItem(context, 'Blogs', '/blogs'),
                _buildNavItem(context, 'Contact', '/contact'),
                _buildNavItem(context, 'About', '/about'),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, String route) {
    return TextButton(
      onPressed: () {
        if (ModalRoute.of(context)?.settings.name != route) {
          Navigator.pushNamed(context, route);
        }
      },
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
        ),
      ),
    );
  }
}
