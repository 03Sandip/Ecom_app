import 'dart:developer';
import '../../../models/coupon.dart';
import '../../login_screen/provider/user_provider.dart';
import '../../../services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/api_response.dart';
import '../../../utility/constants.dart';
import '../../../utility/snack_bar_helper.dart';

class CartProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final box = GetStorage();
  Razorpay razorpay = Razorpay();
  final UserProvider _userProvider;
  var flutterCart = FlutterCart();
  List<CartModel> myCartItems = [];

  final GlobalKey<FormState> buyNowFormKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController couponController = TextEditingController();
  bool isExpanded = false;

  Coupon? couponApplied;
  double couponCodeDiscount = 0;
  String selectedPaymentOption = 'prepaid';

  CartProvider(this._userProvider);

  //TODO: should complete updateCart

  //TODO: should complete getCartSubTotal

  //TODO: should complete getGrandTotal

  //TODO: should complete getCartItems

  //TODO: should complete clearCartItems


  //TODO: should complete checkCoupon

  //TODO: should complete getCouponDiscountAmount


  //TODO: should complete submitOrder

  //TODO: should complete addOrder

  //TODO: should complete cartItemToOrderItem


  clearCouponDiscount() {
    couponApplied = null;
    couponCodeDiscount = 0;
    couponController.text = '';
    notifyListeners();
  }

  void retrieveSavedAddress() {
    phoneController.text = box.read(PHONE_KEY) ?? '';
    streetController.text = box.read(STREET_KEY) ?? '';
    cityController.text = box.read(CITY_KEY) ?? '';
    stateController.text = box.read(STATE_KEY) ?? '';
    postalCodeController.text = box.read(POSTAL_CODE_KEY) ?? '';
    countryController.text = box.read(COUNTRY_KEY) ?? '';
  }

  Future<void> stripePayment({required void Function() operation}) async {
    try {
      Map<String, dynamic> paymentData = {
        "email": _userProvider.getLoginUsr()?.name,
        "name": _userProvider.getLoginUsr()?.name,
        "address": {
          "line1": streetController.text,
          "city": cityController.text,
          "state": stateController.text,
          "postal_code": postalCodeController.text,
          "country": "US"
        },
        "amount":  100, //TODO: should complete amount grand total
        "currency": "usd",
        "description": "Your transaction description here"
      };
      Response response = await service.addItem(endpointUrl: 'payment/stripe', itemData: paymentData);
      final data = await response.body;
      final paymentIntent = data['paymentIntent'];
      final ephemeralKey = data['ephemeralKey'];
      final customer = data['customer'];
      final publishableKey = data['publishableKey'];

      Stripe.publishableKey = publishableKey;
      BillingDetails billingDetails = BillingDetails(
        email: _userProvider.getLoginUsr()?.name,
        phone: '91234123908',
        name: _userProvider.getLoginUsr()?.name,
        address: Address(
            country: 'US',
            city: cityController.text,
            line1: streetController.text,
            line2: stateController.text,
            postalCode: postalCodeController.text,
            state: stateController.text
            // Other address details
            ),
        // Other billing details
      );
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'MOBIZATE',
          paymentIntentClientSecret: paymentIntent,
          customerEphemeralKeySecret: ephemeralKey,
          customerId: customer,
          style: ThemeMode.light,
          billingDetails: billingDetails,
          // googlePay: const PaymentSheetGooglePay(
          //   merchantCountryCode: 'US',
          //   currencyCode: 'usd',
          //   testEnv: true,
          // ),
          // applePay: const PaymentSheetApplePay(merchantCountryCode: 'US')
        ),
      );

      await Stripe.instance.presentPaymentSheet().then((value) {
        log('payment success');
        //? do the success operation
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Payment Success')),
        );
        operation();
      }).onError((error, stackTrace) {
        if (error is StripeException) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(content: Text('${error.error.localizedMessage}')),
          );
        } else {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(content: Text('Stripe Error: $error')),
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> razorpayPayment({required void Function() operation}) async {
    try {
      Response response = await service.addItem(endpointUrl: 'payment/razorpay', itemData: {});
      final data = await response.body;
      String? razorpayKey = data['key'];
      if (razorpayKey != null && razorpayKey != '') {
        var options = {
          'key': razorpayKey,
          'amount': 100, //TODO: should complete amount grand total
          'name': "user",
          "currency": 'INR',
          'description': 'Your transaction description',
          'send_sms_hash': true,
          "prefill": {"email": _userProvider.getLoginUsr()?.name, "contact": ''},
          "theme": {'color': '#FFE64A'},
          "image": 'https://store.rapidflutter.com/digitalAssetUpload/rapidlogo.png',
        };
        razorpay.open(options);
        razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) {
          operation();
          return;
        });
        razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
          SnackBarHelper.showErrorSnackBar('Error ${response.message}');
          return;
        });
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('Error$e');
      return;
    }
  }

  void updateUI() {
    notifyListeners();
  }
}
