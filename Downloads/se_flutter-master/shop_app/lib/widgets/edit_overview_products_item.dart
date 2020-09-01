import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';
import '../providers/products_info.dart';

class UserProdItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProdItem({this.imageUrl, this.title, this.id});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        //trailing can't be a row because it will take full width,
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                  arguments: id,
                );
              },
              color: Theme.of(context).accentColor,
            ),
            IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                Provider.of<Products>(context, listen: false).deleteProduct(id);
              },
              color: Theme.of(context).accentColor,
            ),
          ],
        ),
      ),
    );
  }
}
