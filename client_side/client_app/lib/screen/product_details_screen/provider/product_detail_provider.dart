import 'package:flutter/cupertino.dart';
import 'package:flutter_cart/flutter_cart.dart';
import '../../../core/data/data_provider.dart';


class ProductDetailProvider extends ChangeNotifier {
  final DataProvider _dataProvider;
  String? selectedVariant;
  var flutterCart = FlutterCart();

  ProductDetailProvider(this._dataProvider);

  //TODO: should complete addToCart


  void updateUI() {
    notifyListeners();
  }
}
