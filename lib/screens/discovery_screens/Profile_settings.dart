import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled2/screens/signinAndSignup/Register.dart';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Register()),
                        (Route<dynamic> route) => false);
              },
              child: Text('SignOUt'.toUpperCase()),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary:
                Color.fromRGBO(249, 168, 38, 1),
                //shadowColor: Color.fromRGBO(249, 0, 38, 1),
                elevation: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
