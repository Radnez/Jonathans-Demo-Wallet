import 'package:flutter/material.dart';

import '../../config/constants/text_styles.dart';
import '../../config/routes/routes.dart';

class HeaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const HeaderAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: kTextStyleBlackBold(context, 22),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_circle_left, size: 30),
        onPressed: () {
          Navigator.pushReplacementNamed(context, Routes.paymentMethod);
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
