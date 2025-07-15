import 'package:get/get.dart';
import '../../screens/main/main_screen.dart';
import '../../screens/login/login_page.dart'; // ✅ Make sure LoginPage is defined here

class AppPages {
  static const LOGIN = '/login';
  static const HOME = '/';

  static final routes = [
    GetPage(
      name: LOGIN,
      fullscreenDialog: true,
      page: () => LoginPage(), // ✅ LoginPage should be defined
    ),
    GetPage(
      name: HOME,
      fullscreenDialog: true,
      page: () => MainScreen(),
    ),
  ];
}


// import 'package:get/get_navigation/src/routes/get_route.dart';
// import '../../screens/main/main_screen.dart';



// class AppPages {
//   static const HOME = '/';

//   static final routes = [
//     GetPage(
//       name: HOME,
//       fullscreenDialog: true,
//       page: () => MainScreen()
      
//     ),

//   ];
// }