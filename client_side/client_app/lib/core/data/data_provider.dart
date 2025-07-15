import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../models/category.dart';
import '../../models/api_response.dart';
import '../../models/brand.dart';
import '../../models/order.dart';
import '../../models/poster.dart';
import '../../models/product.dart';
import '../../models/sub_category.dart';
import '../../models/user.dart';
import '../../services/http_services.dart';
import '../../utility/constants.dart';
import '../../utility/snack_bar_helper.dart';

class DataProvider extends ChangeNotifier {
  HttpService service = HttpService();

  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];
  List<Category> get categories => _filteredCategories;

  List<SubCategory> _allSubCategories = [];
  List<SubCategory> _filteredSubCategories = [];

  List<SubCategory> get subCategories => _filteredSubCategories;

  List<Brand> _allBrands = [];
  List<Brand> _filteredBrands = [];
  List<Brand> get brands => _filteredBrands;

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Product> get products => _filteredProducts;
  List<Product> get allProducts => _allProducts;

  List<Poster> _allPosters = [];
  List<Poster> _filteredPosters = [];
  List<Poster> get posters => _filteredPosters;

  List<Order> _allOrders = [];
  List<Order> _filteredOrders = [];
  List<Order> get orders => _filteredOrders;

  DataProvider() {
    // call the method here to load data initially
    getAllProduct();
    getAllCategory();
    getAllSubCategory();
    getAllBrands();
    getAllPosters();
  }

  // getAllCategory-------------------------------------------------------------
  Future<List<Category>> getAllCategory({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'categories');
      if (response.isOk) {
        ApiResponse<List<Category>> apiResponse =
            ApiResponse<List<Category>>.fromJson(
          response.body,
          (json) =>
              (json as List).map((item) => Category.fromJson(item)).toList(),
        );
        _allCategories = apiResponse.data ?? [];
        _filteredCategories =
            List.from(_allCategories); // Initialize filtered list with all data
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _filteredCategories;
  }
  //---------END----------------------------------------------------------------

  // filterCategories-----------------------------------------------------------
  void filterCategories(String keyword) {
    if (keyword.isEmpty) {
      _filteredCategories = List.from(_allCategories);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredCategories = _allCategories.where((category) {
        return (category.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }
  //---------END----------------------------------------------------------------

  // getAllSubCategory----------------------------------------------------------
  Future<List<SubCategory>> getAllSubCategory({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'subCategories');
      if (response.isOk) {
        ApiResponse<List<SubCategory>> apiResponse =
            ApiResponse<List<SubCategory>>.fromJson(
          response.body,
          (json) =>
              (json as List).map((item) => SubCategory.fromJson(item)).toList(),
        ); // ApiResponse.fromJson
        _allSubCategories = apiResponse.data ?? [];
        _filteredSubCategories = List.from(
            _allSubCategories); // Initialize filtered list with all data
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _filteredSubCategories;
  }
  //---------END----------------------------------------------------------------

  // filterSubCategories--------------------------------------------------------
  void filterSubCategories(String keyword) {
    if (keyword.isEmpty) {
      _filteredSubCategories = List.from(_allSubCategories);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredSubCategories = _allSubCategories.where((subcategory) {
        return (subcategory.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }
  //---------END----------------------------------------------------------------

  //getAllBrands----------------------------------------------------------------
  Future<List<Brand>> getAllBrands({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'brands');
      if (response.isOk) {
        ApiResponse<List<Brand>> apiResponse =
            ApiResponse<List<Brand>>.fromJson(
          response.body,
          (json) => (json as List).map((item) => Brand.fromJson(item)).toList(),
        );
        _allBrands = apiResponse.data ?? [];
        _filteredBrands =
            List.from(_allBrands); // Initialize filtered list with all data
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _filteredBrands;
  }
  //---------END----------------------------------------------------------------

  //filterBrands----------------------------------------------------------------
  void filterBrands(String keyword) {
    if (keyword.isEmpty) {
      _filteredBrands = List.from(_allBrands);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredBrands = _allBrands.where((brand) {
        return (brand.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }
//---------END------------------------------------------------------------------

  // getAllProduct--------------------------------------------------------------
  Future<void> getAllProduct({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'products');
      ApiResponse<List<Product>> apiResponse =
          ApiResponse<List<Product>>.fromJson(
        response.body,
        (json) => (json as List).map((item) => Product.fromJson(item)).toList(),
      );
      _allProducts = apiResponse.data ?? [];
      _filteredProducts = List.from(_allProducts);
      notifyListeners();
      if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
    } catch (e) {
      rethrow;
    }
  }
  // end------------------------------------------------------------------------

  //filterProducts--------------------------------------------------------------
  void filterProducts(String keyword) {
    if (keyword.isEmpty) {
      _filteredProducts = List.from(_allProducts);
    } else {
      final lowerKeyword = keyword.toLowerCase();

      _filteredProducts = _allProducts.where((product) {
        final productNameContainsKeyword =
            (product.name ?? '').toLowerCase().contains(lowerKeyword);

        final categoryNameContainsKeyword =
            product.proCategoryId?.name?.toLowerCase().contains(lowerKeyword) ??
                false;

        final subcategoryNameContainsKeyword = product.proSubCategoryId?.name
                ?.toLowerCase()
                .contains(lowerKeyword) ??
            false;

        return productNameContainsKeyword ||
            categoryNameContainsKeyword ||
            subcategoryNameContainsKeyword;
      }).toList();
    }
    notifyListeners();
  }

// end--------------------------------------------------------------------------

//getAllPosters---------------------------------------------------------------
  Future<List<Poster>> getAllPosters({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'posters');
      ApiResponse<List<Poster>> apiResponse =
          ApiResponse<List<Poster>>.fromJson(
        response.body,
        (json) => (json as List).map((item) => Poster.fromJson(item)).toList(),
      );
      _allPosters = apiResponse.data ?? [];
      _filteredPosters = List.from(_allPosters);
      notifyListeners();
      if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
    } catch (e) {
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _filteredPosters;
  }

// end--------------------------------------------------------------------------

  //TODO: should complete getAllOrderByUser

  double calculateDiscountPercentage(num originalPrice, num? discountedPrice) {
    if (originalPrice <= 0) {
      throw ArgumentError('Original price must be greater than zero.');
    }

    //? Ensure discountedPrice is not null; if it is, default to the original price (no discount)
    num finalDiscountedPrice = discountedPrice ?? originalPrice;

    if (finalDiscountedPrice > originalPrice) {
      return originalPrice.toDouble();
    }

    double discount =
        ((originalPrice - finalDiscountedPrice) / originalPrice) * 100;

    //? Return the discount percentage as an integer
    return discount;
  }
}
