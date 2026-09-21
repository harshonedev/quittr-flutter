import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Updated: ${DateTime.now().year}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              '1. Information We Collect',
              'When you create an account, we collect your email address. This is used solely to create your account and to allow you to log in to the app.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              '2. How We Use Your Information',
              'We use your email address to:\n• Create and manage your account\n• Authenticate your login\n• Respond to support requests if you contact us\n\nWe do not use your email address for marketing purposes or share it with third parties.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              '3. Data Storage and Security',
              'Your account information, including your email address, is stored securely. We use industry-standard security measures to protect your data. However, no method of transmission over the internet or electronic storage is completely secure.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              '4. Third-Party Services',
              'Quittr does not use third-party advertising or analytics services that collect your personal data.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              '5. Data Deletion',
              'You can request deletion of your account and associated data at any time by contacting us at support@adulting.space.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              '6. Children\'s Privacy',
              'Quittr is not intended for users under the age of 13. We do not knowingly collect personal information from children.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              '7. Changes to This Policy',
              'We may update this Privacy Policy from time to time. If we make significant changes, we will notify you through the app or by email if appropriate.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              '8. Contact Us',
              'If you have any questions about this Privacy Policy or your data, please contact us at support@adulting.space',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.5,
              ),
        ),
      ],
    );
  }
}
