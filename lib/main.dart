import 'package:flutter/material.dart';
import 'package:s3cloudhub/pages/blog_page.dart';
import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'pages/services_page.dart';
import 'pages/youtube_page.dart';
import 'pages/contact_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const S3CloudHubApp());
}

class S3CloudHubApp extends StatelessWidget {
  const S3CloudHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'S3CloudHub',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/about': (context) => const AboutPage(),
        '/services': (context) => const ServicesPage(),
        '/courses': (context) => const CoursesPage(),
        '/contact': (context) => const ContactPage(),
        '/blogs': (_) => const BlogPage(),
      },
    );
  }
}
