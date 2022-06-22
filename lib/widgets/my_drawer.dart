import 'package:flutter/material.dart';

import '../screens/ItemPage/item_page.dart';
import '../screens/PartiesPage/parties_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text("Invoice Generater"),
          ),
          ListTile(
            title: const Text("Home"),
            leading: const Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Manage Items"),
            leading: const Icon(Icons.add),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const ItemPage()));
              // Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Manage Parties"),
            leading: const Icon(Icons.add),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const PartiesPage()));
              // Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
