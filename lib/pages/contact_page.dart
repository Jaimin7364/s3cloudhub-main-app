import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/header.dart';
import '../components/footer.dart';
import '../components/app_drawer.dart';

/// A more interactive Contact page with animated background, element fade‑ins,
/// and a send button that morphs into a check‑mark when the mail client opens.
class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _msgCtrl = TextEditingController();

  late final AnimationController _bgCtrl;
  late final Animation<Color?> _bgColor1;
  late final Animation<Color?> _bgColor2;

  bool _sending = false;
  bool _sent = false;

  @override
  void initState() {
    super.initState();
    // Looping animation for a subtle shifting gradient background.
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _bgColor1 = ColorTween(
      begin: Colors.indigo.shade700,
      end: Colors.blue.shade400,
    ).animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut));

    _bgColor2 = ColorTween(
      begin: Colors.deepPurple.shade700,
      end: Colors.pink.shade300,
    ).animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut));
  }

  Future<void> _sendEmail() async {
    if (!_formKey.currentState!.validate()) return;

    final subject =
        Uri.encodeComponent('Contact request via S3CloudHub app');
    final body = Uri.encodeComponent(
      'Name: ${_nameCtrl.text}\nEmail: ${_emailCtrl.text}\n\n${_msgCtrl.text}',
    );
    final Uri emailUri = Uri.parse(
        'mailto:contact@s3cloudhub.com?subject=$subject&body=$body');

    setState(() => _sending = true);
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        // Visual feedback: morph button icon to a check‑mark.
        if (mounted) {
          setState(() {
            _sent = true;
          });
          // Reset icon after 2.5 s.
          Timer(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() => _sent = false);
            }
          });
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email app opened!')),
          );
          _formKey.currentState!.reset();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No email app found on this device.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to launch email: $e')),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: AnimatedBuilder(
        animation: _bgCtrl,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _bgColor1.value ?? Colors.indigo,
                  _bgColor2.value ?? Colors.purple,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: child,
          );
        },
        child: SafeArea(
          child: Column(
            children: [
              const Header(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: AnimatedOpacity(
                    opacity: 1,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeIn,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact Us',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 24),
                          _buildAnimatedField(
                            child: TextFormField(
                              controller: _nameCtrl,
                              decoration: _inputDecoration('Name'),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Enter your name'
                                  : null,
                            ),
                            index: 0,
                          ),
                          const SizedBox(height: 16),
                          _buildAnimatedField(
                            child: TextFormField(
                              controller: _emailCtrl,
                              decoration: _inputDecoration('Email'),
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Enter e‑mail';
                                }
                                final emailRegex =
                                    RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
                                return emailRegex.hasMatch(v.trim())
                                    ? null
                                    : 'Invalid e‑mail';
                              },
                            ),
                            index: 1,
                          ),
                          const SizedBox(height: 16),
                          _buildAnimatedField(
                            child: TextFormField(
                              controller: _msgCtrl,
                              decoration: _inputDecoration('Message'),
                              maxLines: 5,
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? 'Enter message'
                                      : null,
                            ),
                            index: 2,
                          ),
                          const SizedBox(height: 30),
                          _buildAnimatedField(
                            index: 3,
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: _sending
                                      ? const SizedBox(
                                          key: ValueKey('loader'),
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2, color: Colors.white),
                                        )
                                      : Icon(
                                          _sent ? Icons.check : Icons.send,
                                          key: ValueKey(_sent ? 'check' : 'send'),
                                        ),
                                ),
                                label: Text(_sent ? 'Sent!' : 'Send'),
                                onPressed: _sending ? null : _sendEmail,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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

  // Common decoration with semi‑transparent field backgrounds.
  InputDecoration _inputDecoration(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      );

  /// Build slide‑in animation (from 30 px below) for each form element.
  Widget _buildAnimatedField({required Widget child, required int index}) {
    final animationDelay = (index + 1) * 100; // ms
    return _DelayedTweenAnimation(
      delay: Duration(milliseconds: animationDelay),
      child: child,
    );
  }
}

/// Helper widget to add delay before starting TweenAnimationBuilder.
class _DelayedTweenAnimation extends StatefulWidget {
  final Duration delay;
  final Widget child;

  const _DelayedTweenAnimation({
    required this.delay,
    required this.child,
  });

  @override
  State<_DelayedTweenAnimation> createState() => _DelayedTweenAnimationState();
}

class _DelayedTweenAnimationState extends State<_DelayedTweenAnimation> {
  bool _start = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _start = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(
        begin: const Offset(0, 0.15),
        end: _start ? Offset.zero : const Offset(0, 0.15),
      ),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, offset, _) => Transform.translate(
        offset: offset * 40,
        child: widget.child,
      ),
    );
  }
}
