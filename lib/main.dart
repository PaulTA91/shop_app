import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products_provider.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/orders_screen.dart';
import './screens/cart_screen.dart';
import '../screens/auth_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_products_screen.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, auth, previous) => Products(
            auth.token,
            previous == null ? [] : previous.items,
          ),
          create: (context) => Products(
            null,
            [],
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Orders(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.purple,
            ).copyWith(
              secondary: Colors.deepOrange,
            ),
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
            AuthScreen.routeName: (context) => AuthScreen(),
          },
        ),
      ),
    );
  }
}
