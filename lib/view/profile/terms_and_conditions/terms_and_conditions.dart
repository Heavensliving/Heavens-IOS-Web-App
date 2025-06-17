import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import for URL handling

class HostelTermsAndConditions extends StatelessWidget {
  const HostelTermsAndConditions({super.key});

  // Function to open URL
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ColorConstants.dark_red.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.home_work,
                      size: 40, color: ColorConstants.dark_red),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Heavens Living Rules & Regulations',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Effective from: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Terms Sections
            _buildTermSection(
              context,
              title: '1. Accommodation Rules',
              points: [
                'No overnight guests allowed without prior permission.',
                'Residents must keep their rooms clean and tidy.',
                'Damage to property will result in penalty charges.',
              ],
            ),

            _buildTermSection(
              context,
              title: '2. Payment Policy',
              points: [
                'Rent must be paid by the 5th of every month.',
                'Late payment will incur a 5% penalty fee.',
                'Security deposit is refundable only if the resident informs about departure at least one month in advance, after deduction of any damages.',
                'No refunds for early termination of stay without prior notice.',
                'Security deposit will be forfeited if proper one-month notice is not given before vacating.',
              ],
            ),

            _buildTermSection(
              context,
              title: '3. Visitor Policy',
              points: [
                'Visitors allowed only in common areas between 8 AM to 8 PM.',
                'All visitors must register at the reception.',
                'Residents are responsible for their visitors\' conduct.',
                'No visitors allowed in rooms without permission.',
              ],
            ),

            _buildTermSection(
              context,
              title: '4. Food & Kitchen',
              points: [
                'Common kitchen available from 6 AM to 10 PM. ',
                'Clean utensils immediately after use.',
                'Food waste must be disposed properly.',
              ],
            ),

            _buildTermSection(
              context,
              title: '5. Prohibited Activities',
              points: [
                'Smoking, alcohol, and drugs are strictly prohibited.',
                'No loud music after 10 PM.',
                'No commercial activities without permission.',
                'No pets allowed in the premises.',
              ],
            ),

            _buildTermSection(
              context,
              title: '6. Safety & Security',
              points: [
                'Main door must be locked after 11 PM.',
                "Don't share access cards/keys with outsiders.",
                'Emergency exits must remain clear at all times.',
                'Report any suspicious activity to management immediately.',
              ],
            ),

            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                _launchUrl('https://www.heavensliving.in/terms&conditions');
              },
              child: Text(
                'View Full Terms & Conditions',
                style: TextStyle(
                  color: ColorConstants.dark_red,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTermSection(
    BuildContext context, {
    required String title,
    required List<String> points,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: .1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorConstants.dark_red2,
            ),
          ),
          const SizedBox(height: 10),
          ...points
              .map((point) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Icon(
                            Icons.circle,
                            size: 6,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            point,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
