import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [];
  // var _showFavoritesOnly= false;
     final String authToken;
  final String userId;
  Products(this.authToken,this.userId,this._items);
  List<Product> get items {
    //if(_showFavoritesOnly){
    //return _items.where((prodItem)=> prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }


  // void showFavoritesOnly(){
  // _showFavoritesOnly=true;
  // notifyListeners();
  // }
  //void showAll(){
  // _showFavoritesOnly=false;
  // notifyListeners();
  //}
  Future<void> fetchAndSetProducts([bool filterByUser=false]) async {
    final filterString=filterByUser?'orderBy="creatorId"equalTo="$userId"':'';
   var url = 'https://shop-7b7fe.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData==null){
        return;
      }
       url = 'https://shop-7b7fe.firebaseio.com/userFavorites/$userId.json?auth=$authToken';

      final favoritrResponse= await http.get(url);
      final favaiteData =json.decode(favoritrResponse.body);
      final List<Product> lodedProducts = [];
      extractedData.forEach((prodId, prodData) {
        lodedProducts.add(Product(
            id: prodId,
          location: prodData['location'],
          name: prodData['name'],
          dayLost: prodData['dayLost'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            isFavorite:favaiteData==null?false:  favaiteData[prodId] ??false,

        ));
      });
      _items = lodedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProuduct(Product product) async {
    final url = 'https://shop-7b7fe.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'name': product.name,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'dayLost': product.dayLost,
            'creatorId':userId,
            'location':product.location,

          }));
      final newProduct = Product(
        name: product.name,
        description: product.description,
        imageUrl: product.imageUrl,
        dayLost: product.dayLost,
        location: product.location,
        id: json.decode(response.body)['name'],
      );

      _items.add(newProduct);
//   items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = 'https://shop-7b7fe.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'name': newProduct.name,
            'location':newProduct.location,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'dayLost': newProduct.dayLost,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print("...");
    }
  }

Future<void> deleteProuduct(String id) async{
    final url = 'https://shop-7b7fe.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex=_items.indexWhere((prod)=>prod.id==id);
    var existingProduct=_items[existingProductIndex];
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
    _items.removeAt(existingProductIndex);
  final response= await  http.delete(url) ;
      if(response.statusCode>=400){
        throw HttpException('could not delete product.');
      }
      existingProduct=null;

    {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();

  }
}}
