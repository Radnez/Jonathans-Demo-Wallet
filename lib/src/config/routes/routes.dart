import 'package:flutter/material.dart';
import '../../core/models/card_details.dart';
import '../../screens/card/add_card_screen.dart';
import '../../screens/card/edit_card_screen.dart';
import '../../screens/country/country_list_screen.dart';
import '../../screens/home/payment_method_screen.dart';

class Routes {
  static const String paymentMethod = '/paymentMethodScreen';
  static const String addCard = '/addCardScreen';
  static const String editCard = '/editCardScreen';
  static const String countryList = '/countryListScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    print('Navigating to: ${settings.name}');
    print('Arguments: ${settings.arguments}');

    switch (settings.name) {
      case paymentMethod:
        return MaterialPageRoute(
          builder: (_) {
            return PaymentMethodScreen();
          },
        );

      case addCard:
        final Function(CardDetails) onCardAdded =
            settings.arguments as Function(CardDetails);
        return MaterialPageRoute(
          builder: (_) {
            return AddCardScreen(onCardAdded: onCardAdded);
          },
        );

      case editCard:
        final CardDetails cardDetails = settings.arguments as CardDetails;
        return MaterialPageRoute(
          builder: (_) {
            return EditCardScreen(cardDetails: cardDetails);
          },
        );

      case countryList:
        return MaterialPageRoute(
          builder: (_) {
            return CountryListScreen();
          },
        );

      default:
        return MaterialPageRoute(
          builder: (_) {
            return Scaffold(
              appBar: AppBar(title: Text("Error")),
              body: Center(
                child: Text("No route defined for ${settings.name}"),
              ),
            );
          },
        );
    }
  }
}
