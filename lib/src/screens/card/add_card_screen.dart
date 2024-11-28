import 'package:demo_wallet/src/core/widgets/header_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/models/card_details.dart';
import '../../core/services/shared_preferences_service.dart';
import '../../core/utils/input_formatter.dart';
import '../../core/utils/responsiveness/responsive_widgets.dart';
import 'card_selection_widget.dart';
import '../country/country_list_screen.dart';
import 'package:uuid/uuid.dart';
import 'card_scanner.dart';

class AddCardScreen extends StatefulWidget {
  final Function(CardDetails) onCardAdded;

  const AddCardScreen({Key? key, required this.onCardAdded}) : super(key: key);

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  String cardType = '';
  String? selectedCountry;
  bool isFormValid = false;

  void validateForm() {
    setState(() {
      isFormValid = _cardNumberController.text.length >= 13 &&
          _cardNumberController.text.length <= 19 &&
          _expiryDateController.text.length == 5 &&
          _cvcController.text.length == 3 &&
          selectedCountry != null;
    });
  }

  Future<void> _saveCardDetails() async {
    if (selectedCountry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a country before saving.')),
      );
      return;
    }

    final newCard = CardDetails(
      id: Uuid().v4(),
      cardNumber: _cardNumberController.text,
      expiryDate: _expiryDateController.text,
      cvc: _cvcController.text,
      selectedCountry: selectedCountry!,
      cardType: cardType.isNotEmpty ? cardType : 'Credit Card',
    );

    await SharedPreferencesService.saveCard(newCard);

    widget.onCardAdded(newCard);

    Navigator.pop(context);
  }

  Future<void> _onCardScanned({
    required String? cardNumber,
    required String? expiryDate,
    required String? cvc,
  }) async {
    setState(() {
      if (cardNumber != null) {
        _cardNumberController.text = cardNumber;
        cardType = SharedPreferencesService.inferCardTypeFromNumber(cardNumber);
      }
      if (expiryDate != null) _expiryDateController.text = expiryDate;
      if (cvc != null) _cvcController.text = cvc;
    });
    validateForm();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      child: Scaffold(
        appBar: HeaderAppBar(title: 'Add Card'),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CardSelectionWidget(
                          initialCardType: cardType,
                          onCardTypeSelected: (selectedType) {
                            setState(() {
                              cardType = selectedType;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Card Number'),
                            Text('Scan Card'),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _cardNumberController,
                                keyboardType: TextInputType.number,
                                maxLength: 19,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  hintText: 'Enter Card Number',
                                  border: InputBorder.none,
                                  counterText: '',
                                ),
                                onChanged: (value) {
                                  validateForm();
                                  String inferredCardType =
                                      SharedPreferencesService
                                          .inferCardTypeFromNumber(value);
                                  setState(() {
                                    cardType = inferredCardType.isNotEmpty
                                        ? inferredCardType
                                        : 'Credit Card';
                                  });
                                },
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.camera_alt_rounded),
                              onPressed: () async {
                                final scannedDetails =
                                    await Navigator.push<Map<String, String?>>(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CardScanner()),
                                );
                                if (scannedDetails != null) {
                                  _onCardScanned(
                                    cardNumber: scannedDetails['cardNumber'],
                                    expiryDate: scannedDetails['expiryDate'],
                                    cvc: scannedDetails['cvc'],
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Expiry Date and CVC
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Exp. Date'),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8), // Reduced vertical padding
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextFormField(
                                controller: _expiryDateController,
                                keyboardType: TextInputType.number,
                                maxLength: 5,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  counterText: '',
                                  hintText: 'MM/YY',
                                  border: InputBorder.none,
                                ),
                                onChanged: (_) => validateForm(),
                                inputFormatters: [expiryDateFormatter()],
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('CVC'),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8), // Reduced vertical padding
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextFormField(
                                controller: _cvcController,
                                keyboardType: TextInputType.number,
                                maxLength: 3,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  counterText: '',
                                  hintText: '123',
                                  border: InputBorder.none,
                                ),
                                onChanged: (_) => validateForm(),
                                textInputAction: TextInputAction.done,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CountryListScreen()),
                        );
                        if (result != null) {
                          setState(() {
                            selectedCountry = result;
                            validateForm();
                          });
                        }
                      },
                      child: Container(
                        height: 60,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedCountry ?? 'Select Country',
                              style: TextStyle(color: Colors.black),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Save Card Button
                  Center(
                    child: GestureDetector(
                      onTap: isFormValid ? _saveCardDetails : null,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isFormValid ? Colors.green : Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Save Card',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
