import 'package:auto_size_text/auto_size_text.dart';
import 'package:credit_card_validate/credit_card_validate.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../elements/PaymentSettingsDialog.dart';
import '../helpers/helper.dart';
import '../models/credit_card.dart';

// ignore: must_be_immutable
class CreditCardsWidget extends StatelessWidget {
  CreditCard creditCard;
  ValueChanged<CreditCard> onChanged;
  String brand;
  
  CreditCardsWidget({
    this.creditCard,
    this.onChanged,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    brand = CreditCardValidator.identifyCardBrand(creditCard.number);
    return Stack(
      
      alignment: AlignmentDirectional.topCenter,
      children: <Widget>[
        Container(
          width: 259,
          height: 165,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), blurRadius: 20, offset: Offset(0, 5)),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 12),
          width: 275,
          height: 177,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), blurRadius: 20, offset: Offset(0, 5)),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 25),
          width: 300,
          height: 195,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), blurRadius: 20, offset: Offset(0, 5)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 21),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                   
                   (brand == 'visa') ? Image.asset('assets/img/visa.png', height: 50,
                     width: 70,) :
                   (brand == 'master_card') ? Image.asset('assets/img/mastercard.png', height: 50,
                     width: 70,) :
                   (brand == 'american_express') ? Image.asset('assets/img/american_express.png', height: 50,
                     width: 70,) :
                   (brand == 'discover') ? Image.asset('assets/img/discover.png', height: 50,
                     width: 70,) :
                   Image.asset('assets/img/stripe.png', height: 50,
                     width: 70,),

                    ButtonTheme(
                      padding: EdgeInsets.all(0),
                      minWidth: 50.0,
                      height: 10.0,
                      child: PaymentSettingsDialog(
                        creditCard: creditCard,
                        onChanged: () {
                          onChanged(creditCard);
                          //setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                AutoSizeText(
                  S.of(context).card_number,
                  style: Theme.of(context).textTheme.caption,
                ),
                AutoSizeText(
                  Helper.getCreditCardNumber(creditCard.number),
                  style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(letterSpacing: 1.4)),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    AutoSizeText(
                      S.of(context).expiry_date,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    AutoSizeText(
                      S.of(context).cvv,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    AutoSizeText(
                      '${creditCard.expMonth}/${creditCard.expYear}',
                      style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(letterSpacing: 1.4)),
                    ),
                    AutoSizeText(
                      creditCard.cvc,
                      style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(letterSpacing: 1.4)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
