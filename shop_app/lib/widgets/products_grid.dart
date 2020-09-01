import 'package:flutter/material.dart';
import './product_item.dart';
import 'package:provider/provider.dart';
import '../providers/products_info.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFav;
  ProductsGrid(this.showOnlyFav);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showOnlyFav ? productsData.favedItems : productsData.items;
    return GridView.builder(
      //only load what can be seen
      padding: const EdgeInsets.all(5),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 9 / 17,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      //this define how a grid should be structured
      //what's the difference between this and SliverGridDelegateWithFixedExtent
      //have to read the

      //this is for notify each single item without rebuild other parts
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        //use value here to recycle the list, use create in main.dart to avoid unneccessary bugs
        //use changenotifier will clean all the data when you switch to another page
        value: products[i],
        child: ProductItem(),
      ), //define how each grid should be built into what widget
      itemCount: products.length,
    );
  }
}
