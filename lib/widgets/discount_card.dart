import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojasouza/models/cart_model.dart';

class DiscountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          'Cupom de Desconto',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Digite seu cupom',
                border: OutlineInputBorder(),
              ),
              initialValue: CartModel.of(context).couponCode ?? "",
              onFieldSubmitted: (text) {
                Firestore.instance
                    .collection('coupons')
                    .document(text)
                    .get()
                    .then((docSnap) {
                  if (docSnap.data != null) {
                    CartModel.of(context)
                        .setCupom(text, docSnap.data['percent']);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Desconto de ${docSnap.data['percent']}% aplicado'),
                      backgroundColor: Theme.of(context).primaryColor,
                    ));
                  } else {
                    CartModel.of(context).setCupom(null, 0);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Cupom não existente!'),
                      backgroundColor: Colors.redAccent,
                    ));
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
