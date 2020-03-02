import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/location_help.dart';
import './coffee_model.dart';
import '../providers/products.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../Screens/product_details_screen.dart';
import '../providers/auth.dart';

class location_personHome extends StatefulWidget {
  static const routeName = '/location-person';
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<location_personHome> {

  GoogleMapController _controller;

  List<Marker> allMarkers = [];

  PageController _pageController;

  int prevPage;


  @override
  void initState() {


 Future.delayed(Duration.zero).then( (_){
   final product=  Provider.of<Product>(context) ;
   allMarkers.add(Marker(
       markerId: MarkerId(product.name),
       draggable: false,
       infoWindow:
       InfoWindow(title: product.name, snippet: product.dayLost),
       position:product.location ));
 });
 super.initState();
//    coffeeShops.forEach((element) {
//      allMarkers.add(Marker(
//          markerId: MarkerId(element.shopName),
//          draggable: false,
//          infoWindow:
//          InfoWindow(title: element.shopName, snippet: element.address),
//          position: element.locationCoords));
//    });
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
  }

  void _onScroll() {
    if (_pageController.page.toInt() != prevPage) {
      prevPage = _pageController.page.toInt();
      moveCamera();
    }
  }

  _coffeeShopList(index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 125.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: LocationHelp(),
    );
  }
  List<Product> _items = [];
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: Text('Maps Lost OF People'),
          centerTitle: true,
        ),
        body: Stack(

          children: <Widget>[

            Container(
              height: MediaQuery.of(context).size.height - 50.0,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(40.7128, -74.0060), zoom: 12.0),
                markers: Set.from(allMarkers),
                onMapCreated: mapCreated,
              ),
            ),
            Positioned(
              bottom: 20.0,
              child: Container(

                height: 200.0,
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount:  _items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _coffeeShopList(index);

                  },
                ),
              ),
            )
          ],
        ));
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  moveCamera() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
       // target: coffeeShops[_pageController.page.toInt()].locationCoords,
         target: _items[_pageController.page.toInt()].location,
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));
  }
}