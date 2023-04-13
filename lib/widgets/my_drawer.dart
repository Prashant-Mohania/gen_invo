import 'package:flutter/material.dart';
import 'package:gen_invo/screens/BackupRestorePage/backup_restore_page.dart';
import 'package:gen_invo/screens/InvoicePage/invoice_page.dart';

import '../screens/ItemPage/item_page.dart';
import '../screens/LastYearInvoice/last_year_invoice_view.dart';
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
          ListTile(
            title: const Text("Manage Invoices"),
            leading: const Icon(Icons.add),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const InvoicePage()));
              // Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Backup/Restore"),
            leading: const Icon(Icons.add),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const BackupRestorePage()));
              // Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Last Year's Data"),
            leading: const Icon(Icons.info),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const LastYearInvoicePage()));
            },
          ),
        ],
      ),
    );
  }
}
