import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final String orderId;
  OrderTile(this.orderId);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection('orders')
              .document(orderId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              int status = snapshot.data['status'];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Código do pedido: ${snapshot.data.documentID}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0),
                  Text(_buildProductsText(snapshot.data)),
                  SizedBox(height: 4.0),
                  Text(
                    'Status do pedido',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCircle('1', 'Preparação', status, 1),
                      Container(
                        height: 1.0,
                        width: 40.0,
                        color: Colors.grey,
                      ),
                      _buildCircle('2', 'Em Transporte', status, 2),
                      Container(
                        height: 1.0,
                        width: 40.0,
                        color: Colors.grey,
                      ),
                      _buildCircle('2', 'Entrega', status, 3),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  String _buildProductsText(DocumentSnapshot snapshot) {
    String text = 'Descrição:\n';
    for (LinkedHashMap p in snapshot.data['products']) {
      text +=
          '${p['quantity']} x ${p['product']['title']} (R\$ ${p['product']['price'].toStringAsFixed(2)})\n';
    }

    text += 'Total: R\$ ${snapshot.data['totalPrice'].toStringAsFixed(2)}';

    return text;
  }

  Widget _buildCircle(
      String title, String subtitle, int status, int thisStatus) {
    Color backColor;
    Widget child;

    if (status < thisStatus) {
      backColor = Colors.grey;
      child = Text(title, style: TextStyle(color: Colors.white));
    } else if (status == thisStatus) {
      backColor = Colors.blueAccent;
      child = Stack(alignment: Alignment.center, children: [
        Text(title, style: TextStyle(color: Colors.white)),
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ]);
    } else {
      backColor = Colors.green;
      child = Icon(Icons.check, color: Colors.white);
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle),
      ],
    );
  }
}
