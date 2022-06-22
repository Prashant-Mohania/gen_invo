import 'package:flutter/cupertino.dart';
import 'package:gen_invo/service/database_service.dart';
import '../Models/party_model.dart';

class PartyChangeNotifier extends ChangeNotifier {
  final DatabaseService dbClient = DatabaseService.instance;
  List<PartyModel> lst = <PartyModel>[];

  fetchPartyList() async {
    await dbClient.getPartyList().then((value) {
      lst = value;
      notifyListeners();
    });
  }

  Future<void> add(PartyModel party) async {
    await dbClient.insertPartyData(party);
    dbClient.getPartyList().then((value) {
      lst = value;
      notifyListeners();
    });
  }

  remove(PartyModel party) async {
    await dbClient.deleteParty(party);
    dbClient.getPartyList().then((value) {
      lst = value;
      notifyListeners();
    });
  }

  update(PartyModel party) async {
    await dbClient.updateParty(party);
    dbClient.getPartyList().then((value) {
      lst = value;
      notifyListeners();
    });
  }
}
