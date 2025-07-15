import '../../../core/data/data_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import '../../../models/product.dart';


class FavoriteProvider extends ChangeNotifier {
  final DataProvider _dataProvider;
  final box = GetStorage();
  List<Product>  favoriteProduct = [];
  FavoriteProvider(this._dataProvider);

  //TODO: should complete updateToFavoriteList

  //TODO: should complete checkIsItemFavorite


  //TODO: should complete loadFavoriteItems

  //TODO: should complete clearFavoriteList

}
