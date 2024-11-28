import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle kTextStyleBlackBold(BuildContext context, double fontSize) {
  return GoogleFonts.roboto(
    textStyle: TextStyle(
      fontSize: fontSize,
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.bold,
    ),
  );
}

TextStyle kTextStyleWhiteBold(BuildContext context, double fontSize) {
  return GoogleFonts.roboto(
    textStyle: TextStyle(
      fontSize: fontSize,
      color: Theme.of(context).colorScheme.secondary,
      fontWeight: FontWeight.bold,
    ),
  );
}

TextStyle kTextStyleGreyBold(BuildContext context, double fontSize) {
  return GoogleFonts.roboto(
    textStyle: TextStyle(
      fontSize: fontSize,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.bold,
    ),
  );
}

TextStyle kTextStyleBlack(BuildContext context, double fontSize) {
  return GoogleFonts.roboto(
    textStyle: TextStyle(
      fontSize: fontSize,
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.normal,
    ),
  );
}

TextStyle kTextStyleWhite(BuildContext context, double fontSize) {
  return GoogleFonts.roboto(
    textStyle: TextStyle(
      fontSize: fontSize,
      color: Theme.of(context).colorScheme.secondary,
      fontWeight: FontWeight.normal,
    ),
  );
}

TextStyle kTextStyleGrey(BuildContext context, double fontSize) {
  return GoogleFonts.roboto(
    textStyle: TextStyle(
      fontSize: fontSize,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.normal,
    ),
  );
}
