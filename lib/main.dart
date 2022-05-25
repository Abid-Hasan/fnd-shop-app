import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/products_provider.dart';
import './screens/products_overview_screen.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => ProductsProvider(),
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.deepOrange,
        fontFamily: 'Lato',
      ),
      home: ProductsOverviewScreen(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: Center(
        child: Text('Let\'s build a shop!'),
      ),
    );
  }
}
