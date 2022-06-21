import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled2/screens/fixedSuggestionPlans.dart';
import 'package:untitled2/screens/maps/ShowMap.dart';
import 'package:untitled2/screens/maps/suggestionPlanMap.dart';
import 'package:untitled2/services/GetData.dart';
import 'package:cached_network_image/cached_network_image.dart';

class imgModel {
  final imgURl;
  final numOfDays;
  final numOfSights;
  final description;

  imgModel({
    this.imgURl,
    this.numOfDays,
    this.numOfSights,
    this.description,
  });
}

class cityPlans extends StatefulWidget {
  const cityPlans({Key? key}) : super(key: key);

  @override
  State<cityPlans> createState() => _cityPlansState();
}

int? numberOfSights;

class _cityPlansState extends State<cityPlans> {
  int numberOfDays = 1;
  String strDays = 'Day';

  @override
  Widget build(BuildContext context) {
    var city = (ModalRoute.of(context)!.settings.arguments as List);
    print(city);
    var data = displayPlans('${city[0]}', numberOfDays);
    numberOfSights = 3 * numberOfDays;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.keyboard_arrow_left,
              color: Color.fromRGBO(249, 168, 38, 1),
              size: 50,
            )),
      ),
      body: Column(
        children: [
          // SizedBox(
          //   width: double.infinity,
          //   height: MediaQuery.of(context).size.height*0.35,
          // ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.01,
              horizontal: MediaQuery.of(context).size.width * 0.04,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: numberOfDays == 1
                        ? Color.fromRGBO(249, 168, 38, 1)
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: numberOfDays == 1
                              ? Colors.transparent
                              : Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: Size(80, 40),
                  ),
                  onPressed: () {
                    setState(() {
                      numberOfDays = 1;
                      strDays = 'Day';
                    });
                  },
                  child: Text(
                    '1 Day',
                    style: TextStyle(
                      color: numberOfDays == 1 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: numberOfDays == 2
                        ? Color.fromRGBO(249, 168, 38, 1)
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: numberOfDays == 2
                              ? Colors.transparent
                              : Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: Size(80, 40),
                  ),
                  onPressed: () {
                    setState(() {
                      numberOfDays = 2;
                      strDays = 'Days';
                    });
                  },
                  child: Text(
                    '2 Days',
                    style: TextStyle(
                      color: numberOfDays == 2 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: numberOfDays == 3
                        ? Color.fromRGBO(249, 168, 38, 1)
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: numberOfDays == 3
                              ? Colors.transparent
                              : Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: Size(80, 40),
                  ),
                  onPressed: () {
                    setState(() {
                      numberOfDays = 3;
                      strDays = 'Days';
                    });
                  },
                  child: Text(
                    '3 Days',
                    style: TextStyle(
                      color: numberOfDays == 3 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
              future: data,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if(snapshot.data.length == 0){
                    return Expanded(
                      child: Center(child: Text(
                        'There is no plans right now',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),),
                    );
                  }
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(
                        18.0,
                      ),
                      child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) => Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  child: Stack(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl:
                                            '${snapshot.data[index]['imgUrl']}',
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                              colorFilter: ColorFilter.mode(
                                                  Colors.black.withOpacity(0.3),
                                                  BlendMode.darken),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15.0,
                                          horizontal: 10.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Icon(
                                                  Icons.calendar_today,
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  size: 18,
                                                ),
                                                numberOfDays > 1
                                                    ? Text(
                                                        '${snapshot.data[index]['numOfDays']} Days',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.white
                                                              .withOpacity(0.8),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    : Text(
                                                        '${snapshot.data[index]['numOfDays']} Day',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.white
                                                              .withOpacity(0.8),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Icon(
                                                  Icons.remove_red_eye,
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  size: 18,
                                                ),
                                                Text(
                                                  '${snapshot.data[index]['places'].length*snapshot.data[index]['places']['1']['ids'].length} Sights',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white
                                                        .withOpacity(0.8),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 8.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Text(
                                      '${snapshot.data[index]['title']}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.37,
                              child: Material(
                                  type: MaterialType.transparency,
                                  child: InkWell(
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => fixedSuggestionPlans(planDetail: snapshot.data[index]),
                                          )
                                      );

                                      // for (var item in data as List) {
                                      //   print('--------------------');
                                      //   print('number of days ${item['numOfDays']}');
                                      //   print(item['title']);
                                      //   print('number of Plases ${item['plases'].length}');
                                      // }
                                    },
                                    splashColor: Colors.black12,
                                    highlightColor: Colors.black12,
                                  )),
                            ),
                          ],
                        ),
                        separatorBuilder: (context, index) => SizedBox(
                          height: 20,
                        ),
                        itemCount: snapshot.data.length,
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
