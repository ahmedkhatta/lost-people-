import 'dart:collection';

import 'package:flutter/material.dart';
import './providers/great_places.dart';
import './Screens/splash_screen.dart';
import './providers/auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './Screens/user_products_screen.dart';
import './Screens/products_overview_screen.dart';
import './Screens/product_details_screen.dart';
import './providers/products.dart';
import './providers/auth.dart';
import 'package:provider/provider.dart';
import './Screens/edit_product_screen.dart';
import './FORM_INPUTS/location.dart';
import './Screens/auth_screen.dart';
import './helpers/custom_route.dart';



void main() {


  runApp(MyHome());}
class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return MultiProvider(

        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProvider.value(
            value: GreatPlaces(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            builder: (ctx, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
                primarySwatch: Colors.red,
                accentColor: Colors.deepOrange,
                fontFamily: 'lato',
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                })),
            home: auth.isAuth
                ? ProdactsOverViewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetailsScreen.routName: (ctx) => ProductDetailsScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
              location_personHome.routeName: (ctx) => location_personHome(),
            },
          ),
        ));
 }
}
