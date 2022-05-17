import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled2/screens/aiCamera/aiCamera.dart';
import 'package:untitled2/screens/discovery_screens/home_screen.dart';
import 'package:untitled2/screens/discovery_screens/searchScreen.dart';
import 'package:untitled2/screens/home_layout.dart';
import 'package:untitled2/screens/Intro/First_intro.dart';
import 'package:untitled2/screens/discovery_screens/citiesData/city_descripton.dart';
import 'package:untitled2/screens/discovery_screens/discovery_screen.dart';
import 'package:untitled2/screens/maps/ShowMap.dart';
import 'package:untitled2/screens/signinAndSignup/Register.dart';

bool islogin = true;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;
  if(user == null){
    islogin = false;
  }
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        ),

      ),
      // home: Show_Maps(),
      // home: searchScreen(),
      home: islogin? Cupertinolayout(): Register(),
    );
  }
}

