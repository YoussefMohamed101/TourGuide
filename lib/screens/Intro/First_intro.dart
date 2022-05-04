import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled2/screens/Intro/Second_intro.dart';

import '../signinAndSignup/Register.dart';

class Welcome_1 extends StatelessWidget {
  //Color mainColor = Color(0xffb74093);
  //height: MediaQuery.of(context).size.height * 0.03,

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      //backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: SizedBox(
              width: 80,
              height: 100,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Register()),);
                },
                style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(86, 98, 246, 1),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11))),
                child: Text(
                  "Skip",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),

      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  'Discover',
                  style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(86, 98, 246, 1)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'You can discover many cities and many historical antiquities through our app',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                      color: Color.fromRGBO(86, 98, 246, 1),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 400,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("lib/img/intro/1.png"),
                          fit: BoxFit.contain,
                        )),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Welcome_2(),
                        ));
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 15,
                      primary: Color.fromRGBO(249, 168, 38, 1),
                      // onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
