import 'package:flutter/material.dart';

import '../Models/party_model.dart';
import '../screens/PartiesPage/party_details_page.dart';

class PartySearch extends SearchDelegate {
  final List<PartyModel> invoices;

  PartySearch(this.invoices);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<PartyModel> suggestionList = query.isEmpty
        ? invoices
        : invoices.where((element) {
            return (element.name ?? "No Name")
                    .toLowerCase()
                    .startsWith(query.toLowerCase()) ||
                element.city!.toLowerCase().startsWith(query.toLowerCase());
          }).toList();
    return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return suggestionList.isNotEmpty
              ? Card(
                  child: ListTile(
                    title: Text(suggestionList[index].name!),
                    subtitle: Text(
                        "${suggestionList[index].city} / ${suggestionList[index].state}"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => PartyDetailsPage(
                                    party: suggestionList[index],
                                  )));
                    },
                  ),
                )
              : const Center(
                  child: Text("No Data"),
                );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<PartyModel> suggestionList = query.isEmpty
        ? invoices
        : invoices.where((element) {
            return (element.name ?? "No Name")
                    .toLowerCase()
                    .startsWith(query.toLowerCase()) ||
                element.city!.toLowerCase().startsWith(query.toLowerCase());
          }).toList();
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return suggestionList.isNotEmpty
            ? Card(
                child: ListTile(
                  title: Text(suggestionList[index].name!),
                  subtitle: Text(
                      "${suggestionList[index].city} / ${suggestionList[index].state}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PartyDetailsPage(
                          party: suggestionList[index],
                        ),
                      ),
                    );
                  },
                ),
              )
            : const Center(
                child: Text("No Data"),
              );
      },
    );
  }
}
