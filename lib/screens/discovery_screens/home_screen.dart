import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled2/screens/discovery_screens/discovery_screen.dart';
import 'package:untitled2/screens/discovery_screens/searchScreen.dart';
import 'package:untitled2/services/GetData.dart';
import 'package:untitled2/services/authentication.dart';
import 'package:cached_network_image/cached_network_image.dart';

class home_screen extends StatefulWidget {
  @override
  State<home_screen> createState() => _home_screenState();
}

class imgModel {
  final id;
  final title;
  final shortDescription;
  final imgURl;
  final goverName;

  imgModel({
    this.id,
    this.title,
    this.shortDescription,
    this.imgURl,
    this.goverName,
  });
}

List<imgModel> ProgDetails = [
  imgModel(
    id: '1',
    imgURl: 'lib/img/home/pexels-photo-3290075.png',
    title: 'Summer in Egypt',
    shortDescription: '15 differnt places and plans to dicover and visit',
    goverName: 'Cairo',
  ),
  imgModel(
      id: '2',
      imgURl: 'lib/img/home/popular place luxor.png',
      title: 'Find New Places',
      shortDescription: '20 Temples to visit, explore and make adventures',
      goverName: 'Luxor'),
  imgModel(
      id: '3',
      imgURl: 'lib/img/home/popoular place in giza cairo.png',
      title: 'Summer in Egypt',
      shortDescription: '15 differnt places and plans to dicover and visit',
      goverName: 'Giza'),
];


class _home_screenState extends State<home_screen> {

  bool isLoading = true; //set loading to false

  void startTimer() {
    Timer.periodic(const Duration(seconds: 2), (t) {
      setState(() {
        isLoading = false; //set loading to false
      });
      t.cancel(); //stops the timer
    });
  }
  late final Future AuthUser = getUser();
  @override
  Widget build(BuildContext context) {
    //print(userdata);
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // systemOverlayStyle: isLoading? SystemUiOverlayStyle(
          //   statusBarIconBrightness: Brightness.dark,
          //   statusBarColor: Colors.transparent,
          // ):SystemUiOverlayStyle(
          //   statusBarIconBrightness: Brightness.light,
          //   statusBarColor: Colors.transparent,
          // ),
        ),
        body: FutureBuilder(
          future: AuthUser,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.hasData){
              return Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.topStart,
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.35,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: const AssetImage(
                                'lib/img/home/homepage background.png'),
                            fit: BoxFit.fill,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.5), BlendMode.darken),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.1,
                          left: 20,
                          right: 20,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hi, ${snapshot.data[0]}',
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height * 0.01,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      const Text(
                                        'Current Location, ',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Container(
                                        height: 20,
                                        child: TextButton(
                                            style: TextButton.styleFrom(
                                              padding: const EdgeInsets.all(0.0),
                                              alignment: Alignment.topLeft,
                                              primary: Colors.transparent,
                                            ),
                                            onPressed: () {},
                                            child: const Text(
                                              'Egypt',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                decoration:
                                                TextDecoration.underline,
                                                //decorationStyle: TextDecorationStyle.double,
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            ClipOval(
                              child: CachedNetworkImage(imageUrl:snapshot.data[1],fit: BoxFit.fill,height: 60,width: 60,),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => searchScreen(),
                              ));
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 30.0,
                            right: 30.0,
                            top: MediaQuery.of(context).size.height * 0.24,
                          ),
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                20.0,
                              ),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset:
                                  const Offset(1, 3), // changes position of shadow
                                ),
                              ],
                            ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.search,color: const Color.fromRGBO(249, 168, 38, 1)),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width*0.02,
                                    ),
                                    const Text('Where do you want to go?',style: TextStyle(
                                      color: Color.fromRGBO(249, 168, 38, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),)
                                  ],
                                ),
                              ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.04,
                      ),
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top:
                                    MediaQuery.of(context).size.height * 0.02,
                                    bottom: 15.0,
                                    left: 2,
                                  ),
                                  child: const Text(
                                    'What do you want to do?',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                    MediaQuery.of(context).size.width * 0.07,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          // <-- ElevatedButton
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => discovery_screen(),
                                                ));
                                          },
                                          icon: const Icon(
                                            Icons.add_location_outlined,
                                            size: 24.0,
                                          ),
                                          label: Text('Discovery'.toUpperCase()),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                            onPrimary:
                                            const Color.fromRGBO(249, 168, 38, 1),
                                            //shadowColor: Color.fromRGBO(249, 0, 38, 1),
                                            elevation: 10,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          // <-- ElevatedButton
                                          onPressed: () {
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //       builder: (context) => Show_Maps(),
                                            //     ));
                                            setState(() {

                                            });
                                          },
                                          icon: const Icon(
                                            Icons.map,
                                            size: 24.0,
                                          ),
                                          label: Text('MAp'.toUpperCase()),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                            onPrimary:
                                            const Color.fromRGBO(249, 168, 38, 1),
                                            //shadowColor: Color.fromRGBO(249, 0, 38, 1),
                                            elevation: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                    MediaQuery.of(context).size.width * 0.07,
                                    vertical:
                                    MediaQuery.of(context).size.height * 0.01,
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    //height: 40,
                                    child: ElevatedButton(
                                      // <-- ElevatedButton
                                      onPressed: () {},
                                      child: Text(
                                        'Generate plan'.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: const Color.fromRGBO(249, 168, 38, 1),
                                        elevation: 5,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom:
                                    MediaQuery.of(context).size.height * 0.01,
                                    left: 2,
                                  ),
                                  child: Row(
                                    children: const [
                                      Text(
                                        'Popular Places',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SliverGrid(
                            gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200.0,
                              mainAxisSpacing: 30.0,
                              crossAxisSpacing: 20.0,
                              childAspectRatio: 1.0,
                              mainAxisExtent: 244,
                            ),
                            delegate: SliverChildBuilderDelegate(
                                  (context, index) =>
                                  buildProgItem(context, ProgDetails[index]),
                              childCount: ProgDetails.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            if(snapshot.hasError){
              return const Text('Please check your connection and try again');
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      );
  }

  // 1. build item
  Widget buildProgItem(BuildContext context, imgModel ProgDetails) => Stack(
        children: [
          Container(
            width: 200,
            height: 244,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                5.0,
              ),
              image: DecorationImage(
                image: AssetImage('${ProgDetails.imgURl}'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2), BlendMode.darken),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${ProgDetails.title}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.005,
                ),
                Text(
                  '${ProgDetails.shortDescription}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.005,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 18,
                    ),
                    Text(
                      '${ProgDetails.goverName}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.bookmark,
            color: Color.fromRGBO(249, 168, 38, 1),
            size: 30,
          ),
        ],
      );

//Widget buildChatItem() => Padding(
//         padding: const EdgeInsets.all(1.0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Stack(
//                     children: [
//                       Container(
//                         width: 202,
//                         height: 244,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(
//                             5.0,
//                           ),
//                           image: DecorationImage(
//                             image:
//                                 AssetImage('lib/img/pexels-photo-3290075.png'),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Text(
//                                 'Summer in Egypt',
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               Text(
//                                 '15 differnt places and plans to dicover and visit',
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.location_on,
//                                     color: Colors.white,
//                                     size: 18,
//                                   ),
//                                   Text(
//                                     'Cairo',
//                                     style: TextStyle(
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Icon(
//                         Icons.bookmark,
//                         color: Color.fromRGBO(249, 168, 38, 1),
//                         size: 30,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   width: 20,
//                 ),
//                 Expanded(
//                   child: Stack(
//                     children: [
//                       Container(
//                         width: 202,
//                         height: 244,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(
//                             5.0,
//                           ),
//                           image: DecorationImage(
//                             image:
//                                 AssetImage('lib/img/popular place luxor.png'),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Text(
//                                 'Find New Places',
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               Text(
//                                 '20 Temples to visit, explore and make adventures',
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.location_on,
//                                     color: Colors.white,
//                                     size: 18,
//                                   ),
//                                   Text(
//                                     'Luxor',
//                                     style: TextStyle(
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Icon(
//                         Icons.bookmark,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: Stack(
//                     children: [
//                       Container(
//                         width: 202,
//                         height: 244,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(
//                             5.0,
//                           ),
//                           image: DecorationImage(
//                             image: AssetImage('lib/img/cairo.png'),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Text(
//                                 'Summer in Egypt',
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               Text(
//                                 '15 differnt places and plans to dicover and visit',
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.location_on,
//                                     color: Colors.white,
//                                     size: 18,
//                                   ),
//                                   Text(
//                                     'Giza',
//                                     style: TextStyle(
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Icon(
//                         Icons.bookmark,
//                         color: Color.fromRGBO(249, 168, 38, 1),
//                         size: 30,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   width: 20,
//                 ),
//                 Expanded(
//                   child: Stack(
//                     children: [
//                       Container(
//                         width: 202,
//                         height: 244,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(
//                             5.0,
//                           ),
//                           image: DecorationImage(
//                             image: AssetImage('lib/img/Aswan.png'),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Text(
//                                 'Find New Places',
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               Text(
//                                 '20 Temples to visit, explore and make adventures',
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.location_on,
//                                     color: Colors.white,
//                                     size: 18,
//                                   ),
//                                   Text(
//                                     'Aswan',
//                                     style: TextStyle(
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Icon(
//                         Icons.bookmark,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );
}
