import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatefulWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(this.id, this.title, this.imageUrl, {Key key}) : super(key: key);

  @override
  State<UserProductItem> createState() => _UserProductItemState();
}

class _UserProductItemState extends State<UserProductItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.imageUrl),
      ),
      title: Text(widget.title),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: widget.id);
            },
            icon: Icon(Icons.edit),
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deleting', textAlign: TextAlign.center),
                  duration: Duration(seconds: 2),
                ),
              );
              Provider.of<Products>(context, listen: false).deleteProduct(widget.id).then((value) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Item deleted', textAlign: TextAlign.center),
                    duration: Duration(seconds: 2),
                  ),
                );
              });
            },
            icon: Icon(Icons.delete),
            color: Theme.of(context).errorColor,
          ),
        ]),
      ),
    );
  }
}
