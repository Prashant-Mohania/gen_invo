import 'package:flutter/material.dart';
import 'package:gen_invo/screens/ItemPage/edit_item_page.dart';
import 'package:provider/provider.dart';

import '../../Models/item_change_notifier.dart';
import 'add_item_page.dart';

class ItemPage extends StatelessWidget {
  const ItemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Item Page"),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AddItemPage()));
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Consumer<ItemChangeNotifier>(builder: (context, items, _) {
            return FutureBuilder(
              future: items.fetchItemList(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                        "Something went wrong while fetching data. PLease reopen the app."),
                  );
                }
                if (items.lst.isEmpty) {
                  return const Center(
                    child: Text("No Items Found"),
                  );
                }
                return ListView.builder(
                  itemCount: items.lst.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onLongPress: () async {
                          if (items.lst[index].isDefault == 0) {
                            await items.setDefaultItem(items.lst[index]);
                          }
                        },
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      EditItemPage(item: items.lst[index])));
                        },
                        tileColor: items.lst[index].isDefault != 0
                            ? Colors.blueGrey
                            : Colors.white,
                        title: Text(items.lst[index].title!),
                        subtitle: Text("hsn:- ${items.lst[index].hsn}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => items.remove(items.lst[index]),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
