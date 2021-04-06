import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojasouza/datas/cart_product.dart';
import 'package:lojasouza/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

class CartModel extends Model {
  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  bool isLoading = false;
  UserModel user;
  List<CartProduct> products = [];

  String couponCode;

  int discountPercentage = 0;

  CartModel(this.user) {
    if (user.isLoggedIn()) {
      _loadCartItems();
    }
  }

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .add(cartProduct.converterCarrinhoEmMapaParaArmazenarFirebase())
        .then((salvarOIdDoProduto) {
      cartProduct.cartId = salvarOIdDoProduto.documentID;
    });

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(cartProduct.cartId)
        .delete();

    notifyListeners();
  }

  void decrementProduct(CartProduct cartProduct) {
    cartProduct.quantity--;

    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(cartProduct.cartId)
        .updateData(cartProduct.converterCarrinhoEmMapaParaArmazenarFirebase());

    notifyListeners();
  }

  void incrementProduct(CartProduct cartProduct) {
    cartProduct.quantity++;

    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(cartProduct.cartId)
        .updateData(cartProduct.converterCarrinhoEmMapaParaArmazenarFirebase());

    notifyListeners();
  }

  void updatePrices() {
    notifyListeners();
  }

  double getProductPrice() {
    double price = 0.0;
    for (CartProduct c in products) {
      if (c.productData != null) price += c.quantity * c.productData.price;
    }
    return price;
  }

  double getDiscountPrice() {
    return getProductPrice() * discountPercentage / 100;
  }

  double getShipPrice() {
    return 9.99;
  }

  Future<String> finishOrder() async {
    if (products.length == 0) return null;
    isLoading = true;
    notifyListeners();
    double productsPrice = getProductPrice();
    double discount = getDiscountPrice();
    double shipPrice = getShipPrice();

    DocumentReference refOrder =
        await Firestore.instance.collection('orders').add({
      'clientId': user.firebaseUser.uid,
      'products': products
          .map((e) => e.converterCarrinhoEmMapaParaArmazenarFirebase())
          .toList(),
      'shipPrice': shipPrice,
      'productsPrice': productsPrice,
      'discount': discount,
      'totalPrice': productsPrice - discount + shipPrice,
      'status': 1,
    });

    await Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('orderId')
        .document(refOrder.documentID)
        .setData({'orderId': refOrder.documentID});

    QuerySnapshot query = await Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .getDocuments();

    for (DocumentSnapshot doc in query.documents) {
      doc.reference.delete();
    }

    products.clear();

    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return refOrder.documentID;
  }

  void setCupom(String couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  void _loadCartItems() async {
    QuerySnapshot query = await Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .getDocuments();

    products = query.documents.map((e) => CartProduct.fromDocument(e)).toList();

    notifyListeners();
  }
}
