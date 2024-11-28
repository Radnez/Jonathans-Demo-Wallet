import 'package:flutter/material.dart';
import 'jonathan_profile.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      },
      child: const Icon(Icons.person, size: 28),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }
}
