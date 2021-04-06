import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojasouza/tiles/category_tile.dart';

class ProductsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firestore.instance.collection('products').getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          var dividedTiles = ListTile.divideTiles(
                  tiles: snapshot.data.documents.map<Widget>((doc) {
                    return CategoryTile(doc);
                  }).toList(),
                  color: Colors.grey[500])
              .toList();
          return ListView(
            children: dividedTiles,
          );
        }
      },
    );
  }
}
