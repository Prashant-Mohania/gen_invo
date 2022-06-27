import 'package:flutter/material.dart';
import 'package:gen_invo/Models/party_change_notifier.dart';
import 'package:gen_invo/screens/PartiesPage/add_parties_page.dart';
import 'package:gen_invo/screens/PartiesPage/party_details_page.dart';
import 'package:provider/provider.dart';

import '../../widgets/party_search.dart';

class PartiesPage extends StatelessWidget {
  const PartiesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Parties Page"),
          actions: [
            IconButton(
                onPressed: () {
                  final temp =
                      Provider.of<PartyChangeNotifier>(context, listen: false)
                          .lst;
                  showSearch(context: context, delegate: PartySearch(temp));
                },
                icon: const Icon(Icons.search)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AddPartyPage()));
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Consumer<PartyChangeNotifier>(builder: (context, party, _) {
            return FutureBuilder(
              future: party.fetchPartyList(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                        "Something went wrong while fetching data. PLease reopen the app."),
                  );
                }
                if (party.lst.isEmpty) {
                  return const Center(
                    child: Text("No Parties Found"),
                  );
                }
                return ListView.builder(
                  itemCount: party.lst.length,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PartyDetailsPage(
                                      party: party.lst[index],
                                    )));
                      },
                      title: Text(party.lst[index].name!),
                      subtitle: Text(
                          "${party.lst[index].city} / ${party.lst[index].state}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => party.remove(party.lst[index]),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
