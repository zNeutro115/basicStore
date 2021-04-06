import 'package:flutter/material.dart';
import 'package:lojasouza/tabs/home_tab.dart';
import 'package:lojasouza/tabs/orders_tab.dart';
import 'package:lojasouza/tabs/places_tab.dart';
import 'package:lojasouza/tabs/products_tab.dart';
import 'package:lojasouza/widgets/cart_button.dart';
import 'package:lojasouza/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Produtos'),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: ProductsTab(),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Lojas Físicas'),
            centerTitle: true,
          ),
          body: PlacesTab(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Meus Pedidos'),
            centerTitle: true,
          ),
          body: OrdersTab(),
          drawer: CustomDrawer(_pageController),
        ),
      ],
    );
  }
}
