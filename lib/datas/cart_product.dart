import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojasouza/datas/product_data.dart';

class CartProduct {
  CartProduct();
  String cartId;
  String category;
  String productId;

  int quantity;
  String size;
  ProductData productData;

  CartProduct.fromDocument(DocumentSnapshot document) {
    cartId = document.documentID;
    category = document.data['category'];
    productId = document.data['productId'];
    quantity = document.data['quantity'];
    size = document.data['size'];
  }

  Map<String, dynamic> converterCarrinhoEmMapaParaArmazenarFirebase() {
    return {
      'category': category,
      'productId': productId,
      'quantity': quantity,
      'size': size,
      'product': productData.toResumedMap(),
    };
  }
}
