import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/order.dart';
import '../widgets/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopping Cart',
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => ci.CartItem(
                id: cart.items.values.toList()[i].id,
                price: cart.items.values.toList()[i].price,
                quantity: cart.items.values.toList()[i].quantity,
                title: cart.items.values.toList()[i].title,
                url: cart.items.values.toList()[i].imageUrl,
                orderId: cart.items.keys.toList()[i],
              ),
              itemCount: cart.items.length,
            ),
          ),
          SizedBox(height: 10),
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).accentColor,
                  ),
                  OrderButtonThatCanSpin(cart: cart)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

//extract is widget is for add a spinning circle which is only available for stateful widget
//instead of rebuilding the whole page everytime, we can extract it here
class OrderButtonThatCanSpin extends StatefulWidget {
  const OrderButtonThatCanSpin({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonThatCanSpinState createState() => _OrderButtonThatCanSpinState();
}

class _OrderButtonThatCanSpinState extends State<OrderButtonThatCanSpin> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
            ? null
            : () {
                setState(() {
                  _isLoading = true;
                });
                Provider.of<Order>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(),
                  widget.cart.totalAmount,
                );
                setState(() {
                  _isLoading = false;
                });
                widget.cart.placeOrder();
              },
        child: _isLoading
            ? CircularProgressIndicator()
            : Text(
                'Place Order',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ));
  }
}
