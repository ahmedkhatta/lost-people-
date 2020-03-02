import 'package:flutter/material.dart';

import 'package:shopapp/FORM_INPUTS/location.dart';

import 'package:shopapp/FORM_INPUTS/locations_person.dart';
import '../providers/auth.dart';
import '../Screens/user_products_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friend !'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Lost Of People'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Search by Location'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => location_personHome()),
              );
            },

          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profil'),
            onTap: () {
//              Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => MapSample()),
//              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notofication'),



          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage data person'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              //   Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
              Provider.of<Auth>(context, listen: false).logout();
            },
          )
        ],
      ),
    );
  }
}
