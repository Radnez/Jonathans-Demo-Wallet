import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/card_details.dart';

class SharedPreferencesService {
  static const String _cardKey = 'cardDetailsList';

  static Future<void> saveCards(List<CardDetails> cards) async {
    final prefs = await SharedPreferences.getInstance();
    String encodedList =
        jsonEncode(cards.map((card) => card.toJson()).toList());
    await prefs.setString(_cardKey, encodedList);
  }

  static Future<void> saveCard(CardDetails card) async {
    List<CardDetails> cards = await getCards();

    if (card.cardType.isEmpty) {
      String inferredType = inferCardTypeFromNumber(card.cardNumber);
      card = CardDetails(
        id: card.id,
        cardNumber: card.cardNumber,
        expiryDate: card.expiryDate,
        cvc: card.cvc,
        selectedCountry: card.selectedCountry,
        cardType: inferredType,
      );
    }

    if (!cards.any((existingCard) => existingCard.id == card.id)) {
      cards.add(card);
    }

    await saveCards(cards);
  }

  static Future<List<CardDetails>> getCards() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = prefs.getString(_cardKey);

    if (encodedList == null) return [];

    final List<dynamic> decodedList = jsonDecode(encodedList);

    return decodedList.map((json) {
      final cardDetails = CardDetails.fromJson(json);
      cardDetails.cardType =
          cardDetails.cardType.isEmpty ? 'Credit' : cardDetails.cardType;
      return cardDetails;
    }).toList();
  }

  static Future<void> updateCard(CardDetails updatedCard) async {
    List<CardDetails> cards = await getCards();

    cards = cards.map((card) {
      if (card.id == updatedCard.id) {
        return updatedCard;
      }
      return card;
    }).toList();

    await saveCards(cards);
  }

  static Future<void> removeCard(String cardId) async {
    List<CardDetails> cards = await getCards();

    cards.removeWhere((card) => card.id == cardId);

    await saveCards(cards);
  }

  static String inferCardTypeFromNumber(String cardNumber) {
    if (cardNumber.startsWith('4')) {
      return 'Visa';
    } else if (cardNumber.startsWith('5')) {
      return 'Master';
    }
    return '';
  }
}
