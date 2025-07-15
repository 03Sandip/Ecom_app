import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/api_response.dart';
import '../../../models/variant_type.dart';
import '../../../services/http_services.dart';
import '../../../utility/snack_bar_helper.dart';

class VariantsTypeProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;

  final addVariantsTypeFormKey = GlobalKey<FormState>();
  TextEditingController variantNameCtrl = TextEditingController();
  TextEditingController variantTypeCtrl = TextEditingController();

  VariantType? variantTypeForUpdate;



  VariantsTypeProvider(this._dataProvider);


  //addVariantType
 addVariantType() async {
  try {
    Map<String, dynamic> variantType = {
      'name': variantNameCtrl.text,
      'type': variantTypeCtrl.text,
    };

    final response = await service.addItem(
      endpointUrl: 'variantTypes',
      itemData: variantType,
    );

    if (response.isOk) {
      ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);

      if (apiResponse.success == true) {
        clearFields();
        SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
        log('Variant Type added');
        _dataProvider.getAllVariantType();
      } else {
        SnackBarHelper.showErrorSnackBar(
          'Failed to add Variant Type: ${apiResponse.message}',
        );
      }
    } else {
      SnackBarHelper.showErrorSnackBar(
        'Error ${response.body?['message'] ?? response.statusText}',
      );
    }
  } catch (e) {
    print(e);
    SnackBarHelper.showErrorSnackBar('An error occurred: $e');
    rethrow;
  }
}
// End--------------------------------------------------------------------------

  //updateVariantType-----------------------------------------------------------
  updateVariantType() async {
  try {
    if (variantTypeForUpdate != null) {
      Map<String, dynamic> variantType = {
        'name': variantNameCtrl.text,
        'type': variantTypeCtrl.text,
      };

      final response = await service.updateItem(
        endpointUrl: 'variantTypes',
        itemData: variantType,
        itemId: variantTypeForUpdate?.sId ?? '',
      );

      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);

        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          log('Variant Type updated');
          _dataProvider.getAllVariantType();
        } else {
          SnackBarHelper.showErrorSnackBar(
            'Failed to update Variant Type: ${apiResponse.message}',
          );
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
          'Error ${response.body?['message'] ?? response.statusText}',
        );
      }
    }
  } catch (e) {
    print(e);
    SnackBarHelper.showErrorSnackBar('An error occurred: $e');
    rethrow;
  }
}
// End--------------------------------------------------------------------------


  //submitVariantType-----------------------------------------------------------
  submitVariantType() {
  if (variantTypeForUpdate != null) {
    updateVariantType();
  } else {
    addVariantType();
  }
}
// End--------------------------------------------------------------------------

  // deleteVariantType----------------------------------------------------------
  deleteVariantType(VariantType variantType) async {
  try {
    Response response = await service.deleteItem(
      endpointUrl: 'variantTypes',
      itemId: variantType.sId ?? '',
    );

    if (response.isOk) {
      ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
      if (apiResponse.success == true) {
        SnackBarHelper.showSuccessSnackBar('Variant Type Deleted Successfully');
        _dataProvider.getAllVariantType();
      } else {
        SnackBarHelper.showErrorSnackBar(
          'Failed to delete Variant Type: ${apiResponse.message}',
        );
      }
    } else {
      SnackBarHelper.showErrorSnackBar(
        'Error ${response.body?['message'] ?? response.statusText}',
      );
    }
  } catch (e) {
    print(e);
    SnackBarHelper.showErrorSnackBar('An error occurred: $e');
    rethrow;
  }
}
// end--------------------------------------------------------------------------


  setDataForUpdateVariantTYpe(VariantType? variantType) {
    if (variantType != null) {
      variantTypeForUpdate = variantType;
      variantNameCtrl.text = variantType.name ?? '';
      variantTypeCtrl.text = variantType.type ?? '';
    } else {
      clearFields();
    }
  }

  clearFields() {
    variantNameCtrl.clear();
    variantTypeCtrl.clear();
    variantTypeForUpdate = null;
  }
}
