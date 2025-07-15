## Flutter_ecommerce_app




E-Commerce app is a design implementation of [E-commerce App](https://dribbble.com/shots/15550702-E-commerce-Mobile-App) designed by [Billah](https://dribbble.com/designermasum)

![](https://github.com/SinaSys/flutter_ecommerce_app/blob/master/screenshots/screenshot.png?raw=true)


## Screenshots

Preview                    |   Home screen             |  Product Detail Screen    |  Cart Screen
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/SinaSys/flutter_ecommerce_app/blob/master/screenshots/preview.gif?raw=true)|![](https://github.com/SinaSys/flutter_ecommerce_app/blob/master/screenshots/home_screen.png?raw=true)|![](https://github.com/SinaSys/flutter_ecommerce_app/blob/master/screenshots/detail_screen.png?raw=true)|![](https://github.com/SinaSys/flutter_ecommerce_app/blob/master/screenshots/cart_screen.png?raw=true)

<br/>

## Directory Structure
```
📂lib
 │───main.dart  
 │───📂core  
 |   │──app_data.dart
 |   │──app_theme.dart
 |   │──app_color.dart
 |   └──extensions.dart
 └───📂src
     │────📂model
     │    │──product.dart
     |    │──product_category.dart
     |    │──product_size_type.dart
     |    │──recommended_product.dart
     |    │──categorical.dart
     |    │──numerical.dart
     |    └──bottom_navy_bar_item.dart
     └────📂view
     |    │───📂screen
     |    |   |──home_screen.dart
     |    |   |──product_list_screen.dart
     |    |   |──product_detail_screen.dart
     |    |   |──favorite_screen.dart
     |    |   |──cart_screen.dart
     |    |   └──profile_screen.dart
     |    │───📂widget
     |    |   |──carousel_slider.dart
     |    |   |──product_grid_view.dart
     |    |   |──list_item_selector.dart
     |    |   └──empty_cart.dart
     |    |   └──page_wrapper.dart
     |    └───📂animation
     |        |──animated_switcher_wrapper.dart
     |        └──open_container_wrapper.dart
     └────📂controller
          └──product_controller.dart
```

<br/>

## Dependencies
Package Name        |
:-------------------------|
|[GetX](https://pub.dev/packages/get) 
|[bottom_navy_bar](https://pub.dev/packages/bottom_navy_bar) 
|[smooth_page_indicator](https://pub.dev/packages/smooth_page_indicator)
|[flutter_rating_bar](https://pub.dev/packages/flutter_rating_bar)
|[font_awesome_flutter](https://pub.dev/packages/font_awesome_flutter)
|[animations](https://pub.dev/packages/animations)
|[flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)

<br/>



