import 'package:flutter/material.dart';

class HomeCustomCard extends StatelessWidget {
  const HomeCustomCard({super.key});

  @override
Widget build(BuildContext context) {
  return Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1150), // Increase as needed
      child: Card(
        elevation: 6,
        margin: const EdgeInsets.all(14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isSmallScreen = constraints.maxWidth < 600;
              final imageWidget = ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://res.cloudinary.com/dfj4u4btd/image/upload/v1748852070/etvyqplxj1dwraw3wzue.png',
                  fit: BoxFit.contain,
                  height: 420,
                  width: double.infinity,
                ),
              );
              final textWidget = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Define us!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome to Flown Developer - A Top Web Development Company in India',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '100% Trusted and Registered Company in India with a professional website that provides the best web development and web design services in India. We are a company that offers multi-functional web portals, and we make sure that a well-developed and attractive website can help our clients to record ROI-driven results.',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                    ),
                  ),
                ],
              );

              if (isSmallScreen) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    imageWidget,
                    const SizedBox(height: 24),
                    textWidget,
                  ],
                );
              } else {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 2, child: textWidget),
                    const SizedBox(width: 32),
                    Expanded(flex: 1, child: imageWidget),
                  ],
                );
              }
            },
          ),
        ),
      ),
    ),
  );
}
}