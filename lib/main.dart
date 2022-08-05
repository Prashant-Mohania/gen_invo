import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gen_invo/screens/HomePage/home_page.dart';
import 'package:gen_invo/service/local_database.dart';
import 'package:provider/provider.dart';

import 'Models/invoice_change_notifier.dart';
import 'Models/item_change_notifier.dart';
import 'Models/party_change_notifier.dart';
import 'screens/SetupPage/setup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSetup = false;

  getSetup() {
    LocalDatabase.getSetup("setup").then((value) {
      setState(() {
        isSetup = value;
      });
    });
  }

  @override
  void initState() {
    getSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItemChangeNotifier()),
        ChangeNotifierProvider(create: (_) => PartyChangeNotifier()),
        ChangeNotifierProvider(create: (_) => InvoiceChangeNotifier()),
      ],
      child: MaterialApp(
        title: 'Invoice Generater',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: isSetup ? const HomePage() : const SetupPage(),
      ),
    );
  }
}
