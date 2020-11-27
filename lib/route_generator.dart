import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/pages/OrderTypeTest.dart';
import 'package:food_delivery_app/src/pages/delivery_details.dart';
import 'package:food_delivery_app/src/pages/grubhub_delivery.dart';
import 'package:food_delivery_app/src/pages/postmates_delivery.dart';
import 'package:food_delivery_app/src/pages/stripe_payment.dart';
import 'package:food_delivery_app/src/pages/terms_and_condition_register.dart';
import 'package:food_delivery_app/src/pages/uber_eats_delivery.dart';

import 'src/models/route_argument.dart';
import 'src/pages/cart.dart';
import 'src/pages/category.dart';
import 'src/pages/checkout.dart';
import 'src/pages/debug.dart';
import 'src/pages/delivery_addresses.dart';
import 'src/pages/delivery_pickup.dart';
import 'src/pages/details.dart';
import 'src/pages/food.dart';
import 'src/pages/forget_password.dart';
import 'src/pages/help.dart';
import 'src/pages/languages.dart';
import 'src/pages/login.dart';
import 'src/pages/menu_list.dart';
import 'src/pages/order_success.dart';
import 'src/pages/pages.dart';
import 'src/pages/payment_methods.dart';
import 'src/pages/paypal_payment.dart';
import 'src/pages/profile.dart';
import 'src/pages/razorpay_payment.dart';
import 'src/pages/reviews.dart';
import 'src/pages/settings.dart';
import 'src/pages/signup.dart';
import 'src/pages/splash_screen.dart';
import 'src/pages/tracking.dart';
import 'src/pages/list_stores.dart';
import 'src/pages/list_products.dart';
import 'src/pages/walkthrough.dart';
import 'src/pages/get_location.dart';
import 'src/pages/order_type_selection.dart';
import 'src/pages/terms_and_condition.dart';
import 'src/pages/privacy_policy.dart';
import 'src/pages/contact_goldilocks.dart';
import 'src/pages/testPage.dart';
import 'src/pages/mobile_verification.dart';
import 'src/pages/otp_test.dart';
import 'src/pages/otpTes_result.dart';
import 'src/pages/test_fb_page.dart';
import 'src/pages/test_onboard.dart';
import 'src/pages/phone_verification.dart';
import 'src/pages/covid.dart';
import 'src/pages/biling_details.dart';
import 'src/pages/doordashdelivery.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/Debug':
        return MaterialPageRoute(builder: (_) => DebugWidget(routeArgument: args as RouteArgument));
      case '/Splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/SignUp':
        return MaterialPageRoute(builder: (_) => SignUpWidget());
      case '/SignUp2':
        return MaterialPageRoute(builder: (_) => OTPPart());
      case '/MobileVerification':
        return MaterialPageRoute(builder: (_) => MobileVerification());
      case '/MobileVerification2':
        return MaterialPageRoute(builder: (_) => SignUpWidget());
      case '/Login':
        return MaterialPageRoute(builder: (_) => LoginWidget());
      case '/Profile':
        return MaterialPageRoute(builder: (_) => ProfileWidget());
      case '/Stores':
        return MaterialPageRoute(builder: (_) => StoreList());
      case '/Walkthrough':
        return MaterialPageRoute(builder: (_) => Walkthrough());
      case '/Products':
        return MaterialPageRoute(builder: (_) => ProductList());
      case '/GetLocation':
        return MaterialPageRoute(builder: (_) => GetLocationWidget());
      case '/OrderType':
        return MaterialPageRoute(builder: (_) => OrderType());
      case '/ForgetPassword':
        return MaterialPageRoute(builder: (_) => ForgetPasswordWidget());
      case '/Pages':
        return MaterialPageRoute(builder: (_) => PagesWidget(currentTab: args));
      case '/Details':
        return MaterialPageRoute(builder: (_) => DetailsWidget(routeArgument: args as RouteArgument));
      case '/Menu':
        return MaterialPageRoute(builder: (_) => MenuWidget(routeArgument: args as RouteArgument));
      case '/Food':
        return MaterialPageRoute(builder: (_) => FoodWidget(routeArgument: args as RouteArgument));
      case '/Category':
        return MaterialPageRoute(builder: (_) => CategoryWidget(routeArgument: args as RouteArgument));
      case '/Cart':
        return MaterialPageRoute(builder: (_) => CartWidget(routeArgument: args as RouteArgument));
      case '/Tracking':
        return MaterialPageRoute(builder: (_) => TrackingWidget(routeArgument: args as RouteArgument));
      case '/Reviews':
        return MaterialPageRoute(builder: (_) => ReviewsWidget(routeArgument: args as RouteArgument));
      case '/PaymentMethod':
        return MaterialPageRoute(builder: (_) => PaymentMethodsWidget());
      case '/DeliveryAddresses':
        return MaterialPageRoute(builder: (_) => DeliveryAddressesWidget());
      case '/DeliveryPickup':
        return MaterialPageRoute(builder: (_) => DeliveryPickupWidget(routeArgument: args as RouteArgument));
      case '/Checkout':
        return MaterialPageRoute(builder: (_) => CheckoutWidget());
      case '/CashOnDelivery':
        return MaterialPageRoute(builder: (_) => OrderSuccessWidget(routeArgument: RouteArgument(param: 'Mail Order')));
      case '/PayOnPickup':
        return MaterialPageRoute(builder: (_) => OrderSuccessWidget(routeArgument: RouteArgument(param: 'Store Pick Up')));
      case '/PayPal':
        return MaterialPageRoute(builder: (_) => PayPalPaymentWidget(routeArgument: args as RouteArgument));
      case '/Stripe':
        return MaterialPageRoute(builder: (_) => StripePaymentWidget(routeArgument: args as RouteArgument));
      case '/RazorPay':
        return MaterialPageRoute(builder: (_) => RazorPayPaymentWidget(routeArgument: args as RouteArgument));
      case '/OrderSuccess':
        return MaterialPageRoute(builder: (_) => OrderSuccessWidget(routeArgument: args as RouteArgument));
      case '/Languages':
        return MaterialPageRoute(builder: (_) => LanguagesWidget());
      case '/Help':
        return MaterialPageRoute(builder: (_) => HelpWidget());
      case '/TermsAndConditions':
        return MaterialPageRoute(builder: (_) => TermsAndConditionWidget());
        case '/TermsAndConditionsRegister':
        return MaterialPageRoute(builder: (_) => TermsAndConditionRegisterWidget());
      case '/PrivacyPolicy':
        return MaterialPageRoute(builder: (_) => PrivacyPolicyWidget());
      case '/ContactGoldilocks':
        return MaterialPageRoute(builder: (_) => ContactGoldilocksWidget());
      case '/Covid':
        return MaterialPageRoute(builder: (_) => CovidWidget());
      case '/Settings':
        return MaterialPageRoute(builder: (_) => SettingsWidget());
      case '/testPage':
        return MaterialPageRoute(builder: (_) => TestPage());
      case '/FBtestPage':
        return MaterialPageRoute(builder: (_) => FBTestPage());
      case '/OtpTest':
        return MaterialPageRoute(builder: (_) => OTPTest());
      case '/OtpTestResult':
        return MaterialPageRoute(builder: (_) => Logout());
      case '/Onboarding':
        return MaterialPageRoute(builder: (_) => OnBoarding());
      case '/OrderTypeTest':
        return MaterialPageRoute(builder: (_) => OrderView());
      case '/BillingDetails':
        return MaterialPageRoute(builder: (_) => BilingDetails());
      case '/DeliveryDetails':
        return MaterialPageRoute(builder: (_) => DeliveryDetails());
      case '/DoorDash':
        return MaterialPageRoute(builder: (_) => DoorDashWidget());
      case '/Grubhub':
        return MaterialPageRoute(builder: (_) => GrubhubWidget());
      case '/UberEats':
        return MaterialPageRoute(builder: (_) => UberEatsWidget());
      case '/Postmates':
        return MaterialPageRoute(builder: (_) => PostmatesWidget());
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(builder: (_) => Scaffold(body: SafeArea(child: Text('Route Error'))));
    }
  }
}
