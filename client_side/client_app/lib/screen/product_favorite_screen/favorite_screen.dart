import 'provider/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../widget/product_grid_view.dart';
import '../../utility/app_color.dart';



class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      //TODO: should complete call loadFavoriteItems
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favorites",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColor.darkOrange),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, child) {
              return ProductGridView(
                items: favoriteProvider.favoriteProduct,
              );
            },
          )
      ),
    );
  }
}
