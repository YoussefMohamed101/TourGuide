import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled2/screens/signinAndSignup/Register.dart';
import 'package:untitled2/services/GetData.dart';

class ProfileSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: FutureBuilder(
        future: getUser(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height*0.08,
                left: MediaQuery.of(context).size.width*0.05,
                right: MediaQuery.of(context).size.width*0.05,
              ),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: CachedNetworkImage(imageUrl:userdata[1],fit: BoxFit.fill,height: 60,width: 60,),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.05,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${userdata[0]}',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            '${userdata[2]}',
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.04,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width*0.02,
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height*0.045,
                      child: Stack(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height*0.01,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.map,
                                  size: 30,
                                  // color: Color.fromRGBO(249, 168, 38, 1),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width*0.05,
                                ),
                                const Text(
                                  'My Plans',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox.expand(
                            child: Material(
                                type: MaterialType.transparency,
                                child: InkWell(onTap: () {},)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width*0.02,
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height*0.045,
                      child: Stack(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height*0.01,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.settings,
                                  size: 30,
                                  // color: Color.fromRGBO(249, 168, 38, 1),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width*0.05,
                                ),
                                const Text(
                                  'Settings',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox.expand(
                            child: Material(
                                type: MaterialType.transparency,
                                child: InkWell(onTap: () {},)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width*0.02,
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height*0.045,
                      child: Stack(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height*0.01,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  size: 30,
                                  // color: Color.fromRGBO(249, 168, 38, 1),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width*0.05,
                                ),
                                const Text(
                                  'About App',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox.expand(
                            child: Material(
                                type: MaterialType.transparency,
                                child: InkWell(onTap: () {},)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height*0.2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width*0.02,
                      vertical: MediaQuery.of(context).size.height*0.02,
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height*0.045,
                      child: Stack(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height*0.01,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.exit_to_app,
                                  size: 30,
                                  // color: Color.fromRGBO(249, 168, 38, 1),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width*0.05,
                                ),
                                const Text(
                                  'SignOut',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox.expand(
                            child: Material(
                                type: MaterialType.transparency,
                                child: InkWell(onTap: () async {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) => Register()),
                                          (Route<dynamic> route) => false);
                                },)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }
}
