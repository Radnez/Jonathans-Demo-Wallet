class CardDetails {
  String id;
  String cardNumber;
  String expiryDate;
  String cvc;
  String selectedCountry;
  String cardType;

  CardDetails({
    required this.id,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvc,
    required this.selectedCountry,
    required this.cardType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvc': cvc,
      'selectedCountry': selectedCountry,
      'cardType': cardType,
    };
  }

  factory CardDetails.fromJson(Map<String, dynamic> json) {
    return CardDetails(
      id: json['id'],
      cardNumber: json['cardNumber'],
      expiryDate: json['expiryDate'],
      cvc: json['cvc'],
      selectedCountry: json['selectedCountry'],
      cardType: json['cardType'],
    );
  }
}
