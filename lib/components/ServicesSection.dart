// services_section.dart
import 'package:flutter/material.dart';
import 'package:s3cloudhub/pages/services_page.dart';
// import 'services_page.dart'; // import ServiceCard and services list

class ServicesSection extends StatelessWidget {
  final void Function() onSeeAllPressed;

  const ServicesSection({Key? key, required this.onSeeAllPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Our Services',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: ServicesPage.services.take(3).map((service) => ServiceCard(
            title: service['title']!,
            description: service['description']!,
            icon: ServicesPage.getIcon(service['icon']!),
          )).toList(),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: onSeeAllPressed,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text('See All Services', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }
}
