import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../providers/products_info.dart';
import './cart_screen.dart';

enum AppBarToggle {
  Favorite,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/overview';
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFav = false;
  var _isInit = true;
  var _isLoading = false;

  //we can't use of.(context) in initState
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchProduct().then((_) => {
            setState(() {
              _isLoading = false;
            })
          });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshPage(BuildContext ct) async {
    await Provider.of<Products>(ct).fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MyShop',
        ),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (AppBarToggle choice) {
              setState(() {
                if (choice == AppBarToggle.Favorite) {
                  _showOnlyFav = true;
                } else {
                  _showOnlyFav = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Favorite'),
                value: AppBarToggle.Favorite,
              ),
              PopupMenuItem(
                child: Text('All'),
                value: AppBarToggle.All,
                //to replace the 0 and 1 to give it more specific meanings
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (context, cartData, chil) => Badge(
              child: chil,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => _refreshPage(context),
              child: ProductsGrid(_showOnlyFav)),
    );
  }
}
