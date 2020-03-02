import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../Screens/product_details_screen.dart';
import '../providers/auth.dart';

import '../providers/product.dart';

class ProductItem extends StatelessWidget {
//  final String id;
  // final String title;
  // final String imageUrl;
//  ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);

    final authData = Provider.of<Auth>(context, listen: false);
    return Container(
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: GridTile(
          child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  ProductDetailsScreen.routName,
                  arguments: product.id,
                );
              },
              child: Hero(
                tag: product.id,
                child: Container(
                  child: FadeInImage(
                    placeholder:
                        AssetImage('assets/images/_product-placeholder.jpg'),
                    image: NetworkImage(product.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              )),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (ctx, product, child) => IconButton(
                icon: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  product.toggleFavoriteStatus(
                    authData.token,
                    authData.userId,
                  );
                },
                color: Theme.of(context).accentColor,
              ),
            ),
            title: Text(
              product.name,
              textAlign: TextAlign.center,
            ),

            trailing: IconButton(
              icon: Icon(Icons.forward),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  ProductDetailsScreen.routName,
                  arguments: product.id,
                );
 //             cart.addItem(product.id, product.price, product.title);
//              Scaffold.of(context).hideCurrentSnackBar();
//              Scaffold.of(context).showSnackBar(SnackBar(
//                content: Text(
//                  'Added Item To Cart!',
//                  textAlign: TextAlign.center,
//                ),
//                duration: Duration(seconds: 2),
////                action: SnackBarAction(
////                  label: 'UNDO',
////                  onPressed: () {
////                    cart.removeSingleItem(product.id);
////                  },
////                ),
//              ));
              },
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
