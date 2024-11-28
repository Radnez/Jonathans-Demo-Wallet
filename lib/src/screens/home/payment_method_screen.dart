import 'package:demo_wallet/src/config/constants/text_styles.dart';
import 'package:demo_wallet/src/screens/jonathan/profile_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/routes/routes.dart';
import '../../config/themes/theme_provider.dart';
import '../../core/models/card_details.dart';
import '../../core/services/shared_preferences_service.dart';
import '../../core/utils/responsiveness/responsive_widgets.dart';
import 'gesture_detector_tile.dart';

class PaymentMethodScreen extends StatefulWidget {
  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  List<CardDetails> cardDetailsList = [];

  @override
  void initState() {
    super.initState();
    loadCards();
  }

  void loadCards() async {
    List<CardDetails> cards = await SharedPreferencesService.getCards();

    for (var card in cards) {
      card.cardType = card.cardType.isEmpty ? 'Default Card' : card.cardType;
    }

    setState(() {
      cardDetailsList = cards;
    });
  }

  void navigateToAddCardScreen() {
    Navigator.pushNamed(
      context,
      Routes.addCard,
      arguments: (CardDetails cardDetails) {
        String inferredCardType =
            SharedPreferencesService.inferCardTypeFromNumber(
                cardDetails.cardNumber);

        cardDetails = CardDetails(
          id: cardDetails.id,
          cardNumber: cardDetails.cardNumber,
          expiryDate: cardDetails.expiryDate,
          cvc: cardDetails.cvc,
          selectedCountry: cardDetails.selectedCountry,
          cardType: inferredCardType,
        );
        SharedPreferencesService.saveCard(cardDetails);

        setState(() {
          loadCards();
        });
      },
    );
  }

  void navigateToEditCardScreen(CardDetails selectedCard) {
    Navigator.pushNamed(
      context,
      Routes.editCard,
      arguments: selectedCard,
    ).then((_) {
      setState(() {
        loadCards();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.12),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0 * (MediaQuery.of(context).size.width / 375),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/icons/credit-card.png',
                      width: 35 * (MediaQuery.of(context).size.width / 375),
                      height: 35 * (MediaQuery.of(context).size.height / 667),
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Payment Methods',
                      style: kTextStyleBlackBold(context,
                          22 * (MediaQuery.of(context).size.width / 375)),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(
                        context.read<ThemeProvider>().themeMode ==
                                ThemeMode.light
                            ? Icons.dark_mode
                            : Icons.light_mode,
                      ),
                      onPressed: () {
                        context.read<ThemeProvider>().toggleTheme();
                      },
                    ),
                  ],
                ),
              ),
              // Payment Methods List
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: cardDetailsList.length,
                itemBuilder: (context, index) {
                  final card = cardDetailsList[index];

                  return GestureDetectorTile(
                    cardDetails: card,
                    onTap: () => navigateToEditCardScreen(card),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0 * (MediaQuery.of(context).size.width / 375),
                ),
                child: GestureDetector(
                  onTap: navigateToAddCardScreen,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        padding: EdgeInsets.all(
                            5 * (MediaQuery.of(context).size.width / 375)),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 24 * (MediaQuery.of(context).size.width / 375),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Add Payment Method',
                        style: kTextStyleGreyBold(context,
                            18 * (MediaQuery.of(context).size.width / 375)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: ProfileButton(),
      ),
    );
  }
}
