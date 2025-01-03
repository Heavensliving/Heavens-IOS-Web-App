import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:heavens_students/controller/cafe_controller/CafeController.dart';
import 'package:heavens_students/controller/cart_controller.dart';
import 'package:heavens_students/controller/connectivity_controlller/connectivity_icon.dart';
import 'package:heavens_students/controller/homepage_controller/HomepageController.dart';
import 'package:heavens_students/controller/homepage_controller/carousal_controller.dart';
import 'package:heavens_students/controller/login_controller/LoginController.dart';
import 'package:heavens_students/controller/mess_controller/MessController.dart';
import 'package:heavens_students/controller/order_controller/order_controller.dart';
import 'package:heavens_students/controller/other_functions/otherFunctions.dart';
import 'package:heavens_students/controller/profile_controller/ProfileController.dart';
import 'package:heavens_students/controller/profile_controller/profilePic_controller.dart';
import 'package:heavens_students/firebase_options.dart';
import 'package:heavens_students/view/MessManager/AddOnPage/AddonPage.dart';
import 'package:heavens_students/view/homepage/homepage.dart';
import 'package:heavens_students/view/homepage/payment_history/payment_history.dart';
import 'package:heavens_students/view/homepage/raised_tickets/raised_tickets.dart';
import 'package:heavens_students/view/no_internet_screen/noInternetScreen.dart';
import 'package:heavens_students/view/profile/change_password/ChangePassword.dart';
import 'package:heavens_students/view/profile/personal_information/PersonalInformation.dart';
import 'package:heavens_students/view/profile/stay_details/StayDetails.dart';
import 'package:heavens_students/view/sign_In/SignIn.dart';
import 'package:heavens_students/view/splash_screen/SplashScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(HeavensStudent());
}

class HeavensStudent extends StatefulWidget {
  const HeavensStudent({super.key});

  @override
  State<HeavensStudent> createState() => _HeavensStudentState();
}

class _HeavensStudentState extends State<HeavensStudent> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(create: (context) => Otherfunctions()),
        ChangeNotifierProvider(create: (context) => MessController()),
        ChangeNotifierProvider(create: (context) => HomepageController()),
        ChangeNotifierProvider(create: (context) => PicController()),
        ChangeNotifierProvider(create: (context) => CafeController()),
        ChangeNotifierProvider(create: (context) => CartController()),
        ChangeNotifierProvider(create: (context) => NetworkController()),
        ChangeNotifierProvider(create: (context) => OrderController()),
        ChangeNotifierProvider(create: (context) => CarousalImageController()),
      ],
      child: Consumer<NetworkController>(
        builder: (context, networkController, child) {
          // if (networkController.connectivityResult == ConnectivityResult.none) {
          //   WidgetsBinding.instance.addPostFrameCallback((_) {
          //     networkController.handleNavigation(context);
          //   });
          // }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
            routes: {
              'home': (context) => const Homepage(),
              '/raised': (context) => const RaisedTickets(),
              '/payment_history': (context) => const PaymentHistory(),
              '/signin': (context) => const Signin(),
              '/personal_information': (context) => const PersonalInformation(),
              '/change_password': (context) => const ChangePassword(),
              '/stay_detail': (context) => const StayDetails(),
              '/mealselection': (context) => MealSelectionPage(),
              // '/forgotpsd': (context) => ForgotPassword(),
              '/nointernet': (context) => NoInternetScreen(),
            },
          );
        },
      ),
    );
  }
}
