import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled2/screens/Intro/Third_intro.dart';

import '../signinAndSignup/Register.dart';

class Welcome_2 extends StatelessWidget {
  //Color mainColor = Color(0xffb74093);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      //backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Color.fromRGBO(86, 98, 246, 1),
              size: 50,
            )),
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
                Container(
                  width: double.infinity,
                  height: 400,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("lib/img/intro/2.png"),
                          fit: BoxFit.contain,
                        )),
                  ),
                ),
                Text(
                  'Navigation',
                  style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(86, 98, 246, 1)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0),
                  child: Text(
                    'You can use our navigation system to explore many cities',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                      color: Color.fromRGBO(86, 98, 246, 1),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Welcome_3(),
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
