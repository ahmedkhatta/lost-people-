import 'package:flutter/foundation.dart';
import './product.dart';
class GreatPlaces with ChangeNotifier{
  List <Product> _items =[];
  List<Product> get items{
    return[..._items];
  }
}