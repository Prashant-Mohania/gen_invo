import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'Models/invoice_change_notifier.dart';
import 'Models/item_change_notifier.dart';
import 'Models/party_change_notifier.dart';
import 'screens/InvoicePage/invoice_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        home: const InvoicePage(),
      ),
    );
  }
}
