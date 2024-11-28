import 'package:flutter/material.dart';

class CardSelectionWidget extends StatefulWidget {
  final Function(String) onCardTypeSelected;
  final String initialCardType;

  const CardSelectionWidget({
    Key? key,
    required this.onCardTypeSelected,
    this.initialCardType = '',
  }) : super(key: key);

  @override
  _CardSelectionWidgetState createState() => _CardSelectionWidgetState();
}

class _CardSelectionWidgetState extends State<CardSelectionWidget> {
  int _selectedCard = 0;

  @override
  void initState() {
    super.initState();
    _updateSelectedCard(widget.initialCardType);
  }

  @override
  void didUpdateWidget(CardSelectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialCardType != oldWidget.initialCardType) {
      _updateSelectedCard(widget.initialCardType);
    }
  }

  void _updateSelectedCard(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        _selectedCard = 2;
        break;
      case 'master':
        _selectedCard = 1;
        break;
      default:
        _selectedCard = 0;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildRadioCard(
              0, 'Credit Card', 'assets/icons/default-card.png', screenWidth),
          _buildRadioCard(
              1, 'Master Card', 'assets/icons/master-card.png', screenWidth),
          _buildRadioCard(2, 'Visa', 'assets/icons/visa-card.png', screenWidth),
        ],
      ),
    );
  }

  Widget _buildRadioCard(
      int value, String title, String imageAsset, double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      width: screenWidth * 0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, textAlign: TextAlign.center),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio<int>(
                value: value,
                groupValue: _selectedCard,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedCard = newValue!;
                    widget.onCardTypeSelected(title);
                  });
                },
              ),
              Container(
                width: screenWidth * 0.1,
                height: screenWidth * 0.1,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Image.asset(
                    imageAsset,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
