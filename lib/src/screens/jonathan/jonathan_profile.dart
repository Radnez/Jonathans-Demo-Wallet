import 'package:demo_wallet/src/core/widgets/header_app_bar.dart';
import 'package:flutter/material.dart';
import '../../core/utils/responsiveness/responsive_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      child: Scaffold(
        backgroundColor: Colors.blueGrey[900],
        appBar: HeaderAppBar(title: 'About Me'),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/me.png',
                    height: MediaQuery.of(context).size.width * 0.3,
                    width: MediaQuery.of(context).size.width * 0.3,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                // Name and Title
                Text(
                  'Jonathan Munday',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Text(
                  'Mobile App Developer',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Divider(
                  color: Colors.white54,
                  thickness: 1,
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                const SectionHeader(title: 'Contact'),
                const BulletPoint(text: 'Phone: +27 079 330 7072'),
                const BulletPoint(
                    text: 'Email: jonathan.appdeveloper@gmail.com'),
                const BulletPoint(text: 'Location: Cape Town, South Africa'),
                Divider(
                  color: Colors.white54,
                  thickness: 1,
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                // Skills Section
                const SectionHeader(title: 'Skills'),
                Wrap(
                  spacing: MediaQuery.of(context).size.width * 0.03,
                  runSpacing: MediaQuery.of(context).size.height * 0.015,
                  children: [
                    const SkillChip(label: 'Flutter/Dart'),
                    const SkillChip(label: 'Firebase'),
                    const SkillChip(label: 'Java'),
                    const SkillChip(label: 'React Native'),
                    const SkillChip(label: 'Figma'),
                    const SkillChip(label: 'Stripe Integration'),
                    const SkillChip(label: 'VS Code'),
                    const SkillChip(label: 'HTML/CSS'),
                    const SkillChip(label: 'Android Studio'),
                    const SkillChip(label: 'JavaScript'),
                    const SkillChip(label: 'GitHub'),
                    const SkillChip(label: 'Xcode'),
                    const SkillChip(label: 'Design'),
                    const SkillChip(label: 'Video Editing'),
                    const SkillChip(label: 'Project Management'),
                    const SkillChip(label: 'Flutter Educator'),
                  ],
                ),
                Divider(
                  color: Colors.white54,
                  thickness: 1,
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                // Experience Section
                const SectionHeader(title: 'Experience'),
                const ExperienceCard(
                  title: 'Full-Stack Mobile Developer',
                  company: 'AutoQuotes',
                  duration: 'Aug 2023 - Present',
                  description:
                      'Developed mobile apps with integrated payment systems and geo-location.',
                ),
                const ExperienceCard(
                  title: 'Director & CEO',
                  company: 'RevDev Solutions',
                  duration: 'Nov 2023 - Present',
                  description:
                      'Led a team creating innovative solutions for mobile and web platforms.',
                ),
                const ExperienceCard(
                  title: 'Mobile & Web Designer',
                  company: 'Revelop',
                  duration: 'Jan 2023 - Aug 2023',
                  description:
                      'Created elegant UI/UX designs and programs for international clients.',
                ),
                Divider(
                  color: Colors.white54,
                  thickness: 1,
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                // Portfolio Section
                const SectionHeader(title: 'Portfolio Highlights'),
                const BulletPoint(
                    text:
                        'RevDev Solutions: Director of my own app dev company.'),
                const BulletPoint(
                    text: 'MyWorkoutAI: AI-powered workout assistant.'),
                const BulletPoint(
                    text: 'PFSCreator: Financial statement generator.'),
                const BulletPoint(
                    text:
                        'MMABetClub: UFC gambling website designed and programmed using figma and react-native.'),
                const BulletPoint(text: 'Ask for more! The list goes on..'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.width * 0.045,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.04,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SkillChip extends StatelessWidget {
  final String label;

  const SkillChip({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.width * 0.035,
        ),
      ),
      backgroundColor: Colors.blueGrey[700],
    );
  }
}

class ExperienceCard extends StatelessWidget {
  final String title;
  final String company;
  final String duration;
  final String description;

  const ExperienceCard({
    Key? key,
    required this.title,
    required this.company,
    required this.duration,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.blueGrey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$company | $duration',
            style: TextStyle(
              color: Colors.white70,
              fontSize: MediaQuery.of(context).size.width * 0.035,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Text(
            description,
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
        ],
      ),
    );
  }
}
