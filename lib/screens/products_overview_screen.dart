import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavourites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyShop"),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favourites) {
                  _showOnlyFavourites = true;
                } else {
                  _showOnlyFavourites = false;
                }
              });
            },
            itemBuilder: ((_) => [
                  PopupMenuItem(
                    child: Text("Only Favourites"),
                    value: FilterOptions.Favourites,
                  ),
                  PopupMenuItem(
                    child: Text("Show All"),
                    value: FilterOptions.All,
                  ),
                ]),
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ProductsGrid(_showOnlyFavourites),
    );
  }
}
