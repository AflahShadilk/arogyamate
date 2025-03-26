import 'package:arogyamate/utilities/constant/media_query.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: s.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('About the App'),
                      _buildContentCard(
                        'Arogya Mate is a systematic and user-friendly application designed to streamline daily hospital administration tasks. Our primary focus is to enhance efficiency, reduce workload, and improve time management for healthcare professionals.',
                      ),
                      
                      _buildSectionTitle('How to Use This App'),
                      _buildStepSection(
                        step: 'Step 1: Getting Started',
                        content: [
                          'Arogya Mate features an intuitive interface that’s easy to navigate. After installation:',
                          '- Open the app and explore the welcome screen',
                          '- Proceed to the simple form-filling page',
                          '- Enter the required details to get started',
                        ],
                      ),
                      
                      _buildStepSection(
                        step: 'Step 2: Main Features',
                        content: [
                          _buildFeatureItem(
                            'a. Home Page',
                            [
                              'View hospital photo',
                              'Two shift options:',
                              '- Day Shift: See doctors available in the morning',
                              '- Night Shift: See doctors available at night',
                              'Search functionality to find specific doctors',
                              'Tap doctor names for details and appointments',
                            ],
                          ),
                          _buildFeatureItem(
                            'b. Appointments Page',
                            [
                              'View and manage your appointments',
                              'Access patient details',
                              'Edit or delete appointments',
                              'Search with filters',
                            ],
                          ),
                          _buildFeatureItem(
                            'c. Add Page',
                            [
                              'Section 1: Add appointments with patient details',
                              'Section 2: Add new doctors with their information',
                            ],
                          ),
                          _buildFeatureItem(
                            'd. Doctors Page',
                            [
                              'View all added doctors',
                              'Search doctors using filters',
                              'Options per doctor:',
                              '- Edit doctor details',
                              '- Schedule availability',
                            ],
                          ),
                          _buildFeatureItem(
                            'e. Profile Page',
                            [
                              'Theme changer button',
                              'Profile information',
                              'Simple logout option',
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Widget _buildContentCard(String content) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildStepSection({required String step, required List<dynamic> content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Text(
            step,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.teal,
            ),
          ),
        ),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content.map((item) {
                if (item is String) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  );
                }
                return item as Widget;
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String title, List<String> details) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey,
            ),
          ),
          ...details.map(
            (detail) => Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 4.0),
              child: Text(
                detail,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}