import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Orders')),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: ordersProvider.orders.length,
              itemBuilder: ((ctx, i) => OrderItem(ordersProvider.orders[i])),
            ),
    );
  }
}
