import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class CustomCreditCard extends StatefulWidget {
  final Function(String) onCardNumberChanged;
    const CustomCreditCard({super.key, required this.onCardNumberChanged});

  @override
  State<CustomCreditCard> createState() => _CustomCreditCardState();
}

class _CustomCreditCardState extends State<CustomCreditCard> {
  String cardNumber = '', expiryDate = '', cardHolderName = '', cvvCode = '';
  
  bool showBackView = false;
  final GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CreditCardWidget(
          cardNumber: cardNumber,
          expiryDate: expiryDate,
          cardHolderName: cardHolderName,
          cvvCode: cvvCode,
          showBackView: showBackView,
          onCreditCardWidgetChange: (value) {},
          isHolderNameVisible: true,
        ),
        CreditCardForm(
          cardNumber: cardNumber,
          expiryDate: expiryDate,
          cardHolderName: cardHolderName,
          cvvCode: cvvCode,
           onCreditCardModelChange: (CreditCardModel model) {
            setState(() {
              cardHolderName = model.cardHolderName;
              expiryDate = model.expiryDate;
              cardNumber = model.cardNumber;
              cvvCode = model.cvvCode;
              showBackView = model.isCvvFocused;
            });

            widget.onCardNumberChanged(cardNumber);
          },
          formKey: formKey,
        )
      ],
    );
  }
}