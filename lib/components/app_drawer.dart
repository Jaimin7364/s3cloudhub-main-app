import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Center(
              child: Image.network(
                'https://res.cloudinary.com/dfj4u4btd/image/upload/v1747645732/untx2kq0npaikwelm7gj.jpg',
                width: 180, // adjust size as needed
                height: 180,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.build_circle),
            title: const Text('Our Services'),
            onTap: () {
              Navigator.pushNamed(context, '/services');
            },
          ),
          ListTile(
            leading: const Icon(Icons.play_circle_fill),
            title: const Text('Courses'),
            onTap: () {
              Navigator.pushNamed(context, '/courses');
            },
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('Blogs'),
            onTap: () {
              Navigator.pushNamed(context, '/blogs');
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Contact Us'),
            onTap: () {
              Navigator.pushNamed(context, '/contact');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),
    );
  }
}
