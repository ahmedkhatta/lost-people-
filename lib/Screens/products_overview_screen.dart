import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Screens/cart_screen.dart';
import 'package:shopapp/providers/cart.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProdactsOverViewScreen extends StatefulWidget {
  @override
  _ProdactsOverViewScreenState createState() => _ProdactsOverViewScreenState();
}

class _ProdactsOverViewScreenState extends State<ProdactsOverViewScreen> {
  var _showOnlyFavorites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MyShop"), actions: <Widget>[
        PopupMenuButton(
          onSelected: (FilterOptions selectValue) {
            setState(() {
              if (selectValue == FilterOptions.Favorites) {
                _showOnlyFavorites = true;
              } else {
                _showOnlyFavorites = false;
              }
            });
          },
          icon: Icon(Icons.more_vert),
          itemBuilder: (_) => [
            PopupMenuItem(
              child: Text("Only Favorites"),
              value: FilterOptions.Favorites,
            ),
            PopupMenuItem(
              child: Text("Show all"),
              value: FilterOptions.All,
            )
          ],
        ),
        Consumer<Cart>(
          builder: (_, cart, ch ) => Badge(
            child: ch,
            value: cart.itemCount.toString(),
          ),
          child: IconButton(
              icon: Icon(Icons.shopping_cart,color: Colors.white,),
              onPressed: (){
            Navigator.of(context).pushNamed(CartScreen.routeName);

              }),
        ),
      ]),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
