import 'package:flutter/material.dart';
import '../../core/models/card_details.dart';

class GestureDetectorTile extends StatelessWidget {
  final CardDetails cardDetails;
  final VoidCallback onTap;

  const GestureDetectorTile({
    Key? key,
    required this.cardDetails,
    required this.onTap,
  }) : super(key: key);

  Widget getCardTypeImage(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return Image.asset('assets/icons/visa-card.png', width: 40, height: 40);
      case 'master card':
        return Image.asset('assets/icons/master-card.png',
            width: 40, height: 40);
      default:
        return Image.asset('assets/icons/default-card.png',
            width: 40, height: 40);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                getCardTypeImage(cardDetails.cardType),
                SizedBox(width: 10),
                Text(
                  '●●●● ${cardDetails.cardNumber.substring(cardDetails.cardNumber.length - 4)}', // Masked digits
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  cardDetails.selectedCountry,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Icon(Icons.arrow_right),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
