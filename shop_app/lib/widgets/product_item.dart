import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

//this reusable widget is the each small product grid that displayed in the product_overview_screen
class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    //by using consumer to the only widget part that rerender, we can use listen to false here to further optimize
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          ProductDetailScreen.routeName,
          arguments: product.id,
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  //picture that its corner should be re-shaped as rounded-cornered as its mother card
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    product.imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 10,
                  child: Consumer<Product>(
                    builder: (context, value, _) => IconButton(
                      icon: product.isFaved
                          ? Icon(Icons.favorite)
                          : Icon(Icons.favorite_border),
                      onPressed: () {
                        product.toggleFavoriteStatus(
                          authData.token,
                          authData.userId,
                        );
                      },
                      color: Theme.of(context).accentColor,
                    ), //only the iconbutton will be re-render, if there's something that will not change, we can put it in the child parameter of this consumer
                    //if you only want to change how a widget look, you can use stateful widget,
                    //but in this case, the isfaved var also has more to do with the faved page so using provider here is a good idea
                  ),
                ),
              ],
            ),
            Container(
              height: 60,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: GridTileBar(
                  //this displayed on the bottom of the child, which is an image
                  title: Text(
                    product.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      cart.addItem(product.id, product.title, product.price,
                          product.imageUrl);
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Added to cart!'),
                        duration: Duration(seconds: 2),
                        action: SnackBarAction(
                            label: 'UNDO',
                            onPressed: () {
                              cart.removeSingleItem(product.id);
                            }),
                      ));
                    },
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
