import 'package:flutter/material.dart';
import 'package:lojasouza/models/user_model.dart';
import 'package:lojasouza/screens/login_screen.dart';
import 'package:lojasouza/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;
  CustomDrawer(this.pageController);
  Widget _constroiFundoDegradeRosa() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              //Color.fromARGB(255, 253, 181, 168),
              Color.fromARGB(255, 211, 118, 130),
              Colors.white
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          _constroiFundoDegradeRosa(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 29.0),
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: Stack(
                  children: [
                    Positioned(
                      top: 30.0,
                      left: 0.0,
                      child: Text(
                        'Loja Teste',
                        style: TextStyle(
                          fontSize: 42.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                        left: 0.0,
                        bottom: 0.0,
                        child: ScopedModelDescendant<UserModel>(
                          builder: (context, child, model) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Olá, ${!model.isLoggedIn() ? '' : model.userData['name']}',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 3),
                                GestureDetector(
                                  child: Text(
                                    !model.isLoggedIn()
                                        ? 'Entre ou Cadastre-se'
                                        : 'Sair',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    if (!model.isLoggedIn()) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()));
                                    } else
                                      model.signOut();
                                  },
                                )
                              ],
                            );
                          },
                        ))
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, 'Inicio', pageController, 0),
              DrawerTile(Icons.list, 'Produtos', pageController, 1),
              DrawerTile(Icons.location_on, 'Lojas', pageController, 2),
              DrawerTile(
                  Icons.playlist_add_check, 'Meus Pedidos', pageController, 3),
            ],
          )
        ],
      ),
    );
  }
}
