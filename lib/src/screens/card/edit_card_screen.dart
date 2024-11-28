import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/models/card_details.dart';
import '../../core/services/shared_preferences_service.dart';
import '../../core/utils/input_formatter.dart';
import '../../core/utils/responsiveness/responsive_widgets.dart';
import '../../core/widgets/header_app_bar.dart';
import '../country/country_list_screen.dart';

class EditCardScreen extends StatefulWidget {
  final CardDetails cardDetails;

  const EditCardScreen({super.key, required this.cardDetails});

  @override
  _EditCardScreenState createState() => _EditCardScreenState();
}

class _EditCardScreenState extends State<EditCardScreen> {
  late TextEditingController _cardNumberController;
  late TextEditingController _expiryDateController;
  late TextEditingController _cvcController;
  late TextEditingController _countryController;
  late String cardType;

  bool _isEditing = false;
  bool _isCardNumberVisible = false;

  @override
  void initState() {
    super.initState();
    _cardNumberController =
        TextEditingController(text: widget.cardDetails.cardNumber);
    _expiryDateController =
        TextEditingController(text: widget.cardDetails.expiryDate);
    _cvcController = TextEditingController(text: widget.cardDetails.cvc);
    _countryController =
        TextEditingController(text: widget.cardDetails.selectedCountry);
    cardType = widget.cardDetails.cardType;
  }

  Future<void> _saveCardDetails() async {
    if (_cardNumberController.text.length != 19 ||
        _expiryDateController.text.length != 5 ||
        _cvcController.text.length != 3 ||
        _countryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields correctly!')),
      );
      return;
    }

    final updatedCard = CardDetails(
      id: widget.cardDetails.id,
      cardNumber: _cardNumberController.text,
      expiryDate: _expiryDateController.text,
      cvc: _cvcController.text,
      selectedCountry: _countryController.text,
      cardType: cardType,
    );

    await SharedPreferencesService.updateCard(updatedCard);
    Navigator.pop(context, updatedCard);
  }

  Future<void> _removeCardDetails() async {
    await SharedPreferencesService.removeCard(widget.cardDetails.id);
    Navigator.pop(context, widget.cardDetails.id);
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvcController.dispose();
    _countryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String assetPath = '';
    switch (cardType) {
      case 'Visa':
        assetPath = 'assets/icons/visa-card.png';
        break;
      case 'Master Card':
        assetPath = 'assets/icons/master-card.png';
        break;
      default:
        assetPath = 'assets/icons/default-card.png';
    }

    return ResponsiveWidget(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: HeaderAppBar(title: 'Edit Payment Method'),
          body: Padding(
            padding: EdgeInsets.all(22.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        assetPath,
                        width: 35,
                        height: 35,
                      ),
                      SizedBox(width: 10),
                      Text(
                        cardType,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      if (_isEditing)
                        Expanded(
                          child: TextField(
                            controller: _cardNumberController,
                            decoration:
                                InputDecoration(hintText: 'Card Number'),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(19),
                            ],
                          ),
                        )
                      else
                        Expanded(
                          child: Text(
                            _isCardNumberVisible
                                ? widget.cardDetails.cardNumber
                                : '●●●● ${widget.cardDetails.cardNumber.substring(widget.cardDetails.cardNumber.length - 4)}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                      if (!_isEditing) Spacer(),
                      if (!_isEditing)
                        IconButton(
                          icon: Icon(
                            _isCardNumberVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () {
                            setState(() {
                              _isCardNumberVisible = !_isCardNumberVisible;
                            });
                          },
                        ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Expiry date',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
                          SizedBox(height: 5),
                          _isEditing
                              ? Container(
                                  width: 120,
                                  child: TextField(
                                    controller: _expiryDateController,
                                    decoration:
                                        InputDecoration(hintText: 'MM/YY'),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      expiryDateFormatter(),
                                    ],
                                  ),
                                )
                              : Text(widget.cardDetails.expiryDate,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('CVC',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
                          SizedBox(height: 5),
                          _isEditing
                              ? Container(
                                  width: 80,
                                  child: TextField(
                                    controller: _cvcController,
                                    decoration:
                                        InputDecoration(hintText: 'CVC'),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(3),
                                    ],
                                  ),
                                )
                              : Text(widget.cardDetails.cvc,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Country of Issue:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      _isEditing
                          ? GestureDetector(
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CountryListScreen()),
                                );
                                if (result != null) {
                                  setState(() {
                                    _countryController.text = result;
                                  });
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _countryController.text.isNotEmpty
                                      ? _countryController.text
                                      : 'Select Country',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            )
                          : Text(widget.cardDetails.selectedCountry,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  SizedBox(height: 20),
                  _isEditing
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: Icon(Icons.save, color: Colors.green),
                              title: Text('Save',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              onTap: _saveCardDetails,
                            ),
                            Divider(),
                          ],
                        )
                      : ListTile(
                          leading: Icon(Icons.edit,
                              color: Theme.of(context).colorScheme.primary),
                          title: Text('Edit',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          onTap: () {
                            setState(() {
                              _isEditing = true;
                            });
                          },
                        ),
                  ListTile(
                    leading: Icon(Icons.cancel, color: Colors.red),
                    title: Text('Remove payment method',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.red)),
                    onTap: () async {
                      final shouldRemove = await showModalBottomSheet<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Remove Card',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Divider(),
                                SizedBox(height: 15),
                                Text(
                                  'Are you sure you want to remove this card?',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 15),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: Text('Remove'),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.red),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                      child: Text('Cancel'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );

                      if (shouldRemove == true) {
                        _removeCardDetails();
                      }
                    },
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
