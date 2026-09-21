import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms of Service',
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
              '1. Use of the App',
              'You may use Quittr only if you are at least 13 years old and agree to comply with these Terms. You are responsible for your use of the App and for any activity that occurs under your account.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              '2. Account Registration',
              'To use certain features of the App, you must create an account using your email address. You agree to provide accurate and complete information and to keep it up to date. You are responsible for maintaining the confidentiality of your account credentials.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              '3. User Content',
              'Any data you input into the app, such as progress tracking or check-ins, is your own content. We do not share this information and it is stored securely. You retain ownership of your data.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              '4. Restrictions',
              'You agree not to:\n• Use the app for any illegal or unauthorized purpose\n• Attempt to reverse engineer or interfere with the app\'s functionality\n• Use the app in a way that could harm or impair others\' use of it',
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              '5. Termination',
              'We reserve the right to suspend or terminate your access to the App at our discretion, without notice, if we believe you have violated these Terms or engaged in harmful behavior.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              '6. Disclaimer',
              'The App is provided for informational and self-improvement purposes only. It does not provide medical or psychological advice. If you are experiencing distress or addiction, please consult a qualified professional.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              '7. Limitation of Liability',
              'To the fullest extent permitted by law, we are not liable for any damages arising from your use of the App. This includes indirect, incidental, or consequential damages.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              '8. Changes to the Terms',
              'We may update these Terms from time to time. When we do, we will revise the effective date and may notify you through the app.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              '9. Contact',
              'If you have any questions about these Terms, please contact us at support@adulting.space',
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
