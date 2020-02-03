import 'package:flutter/material.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders.dart';

import 'package:shopapp/providers/products.dart' as prefix0;
import './Screens/products_overview_screen.dart';
import './Screens/product_details_screen.dart';
import './providers/products.dart';
import 'package:provider/provider.dart';

import 'Screens/cart_screen.dart';
void main() => runApp(MyHome());
 class MyHome extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     return MultiProvider(providers: [
         ChangeNotifierProvider.value(
         value: Products(),),
       ChangeNotifierProvider.value(value: Cart()),
       ChangeNotifierProvider.value(value: Orders()),

     ], 
       child: MaterialApp(
         title: 'MyShop',

         theme: ThemeData(
           primarySwatch: Colors.red,
           accentColor: Colors.deepOrange,
           fontFamily: 'lato',
         ),
         home: ProdactsOverViewScreen(),
         routes: {
           ProductDetailsScreen.routName:(ctx)=>ProductDetailsScreen(),
           CartScreen.routeName:(ctx)=>CartScreen(),


         },
       ),
     );
   }
 }

