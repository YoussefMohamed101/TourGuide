import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled2/auth/secrets.dart';
import 'package:untitled2/screens/discovery_screens/citiesData/FamousPlacesDetails.dart';
import 'package:untitled2/screens/generatePlanForm.dart';
import 'package:untitled2/services/GetData.dart';

class famousPlacesForGenPlan extends StatefulWidget {
  @override
  State<famousPlacesForGenPlan> createState() => _famousPlacesForGenPlanState();
}

class _famousPlacesForGenPlanState extends State<famousPlacesForGenPlan> {
  @override
  Widget build(BuildContext context) {
    var planDetails = (ModalRoute.of(context)!.settings.arguments as List);
    print(PlacesList);
    late final Future cityPlaces = getPlaces(planDetails[0]);
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
        actions: [
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width*0.045,
                top: MediaQuery.of(context).size.height*0.008,
            ),
            child: IconButton(onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => generatePlanForm(),
                  ));
                },
                icon: const Icon(
                  Icons.check,
                  color: Color.fromRGBO(249, 168, 38, 1),
                  size: 40,
                )),
          ),
        ],
      ),
      body: FutureBuilder(
          future: cityPlaces,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List Places = [];
              for(int i = 0; i<snapshot.data.length; i++){
                if(snapshot.data[i]['timesOfWork'][planDetails[2]][0].toString().toLowerCase() != 'closed'){
                  Places.add(
                    snapshot.data[i],
                  );
                }
              }
              if (snapshot.data.length != 0) {
                return CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.02,
                        horizontal:
                        MediaQuery.of(context).size.width * 0.03,
                      ),
                      child: Text('Note: Some places maybe removed because it is closed on the day you select'),
                    )),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.02,
                            horizontal:
                                MediaQuery.of(context).size.width * 0.03,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                width: 1.5,
                                color: Colors.grey,
                              ),
                            ),
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.22,
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            '${Places[index]['imgURL']}'),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(14),
                                        bottomLeft: Radius.circular(14),
                                      ),
                                    ),
                                    height: double.infinity,
                                  ),
                                ),
                                Flexible(
                                  flex: 5,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.02,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03,
                                          ),
                                          child: Text(
                                            '${Places[index]['name']}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          '${Places[index]['information']}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 7,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    //primary: Colors.grey,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => FamousePlacesDetails(),
                                                            settings: RouteSettings(
                                                              arguments: [
                                                                Places[index]['id'],
                                                                planDetails[0]
                                                              ],
                                                            )
                                                        ));
                                                  },
                                                  child: const Text(
                                                    'Read More',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04,
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: !PlacesList.any((item) => item['id'] == Places[index]['id'])? Colors.white: Colors.green,
                                                    onPrimary: !PlacesList.any((item) => item['id'] == Places[index]['id'])? Colors.black: Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                      side: const BorderSide(
                                                          width: 1),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    // PlacesList.add({
                                                    //   'id' : snapshot.data[index]['id'],
                                                    //   'Name': snapshot.data[index]['name']
                                                    // });

                                                    // for(var i in PlacesList){
                                                    //   print(i['id']);
                                                    // }



                                                    if(planDetails[3] == 'Automatic'){
                                                      if(PlacesList.any((item) => item['id'] == Places[index]['id']) == false && PlacesList.length < 3 * int.parse(planDetails[1]) ){
                                                        PlacesList.add({
                                                          'id' : Places[index]['id'],
                                                          'name': Places[index]['name'],
                                                          'img': Places[index]['imgURL'],
                                                          'coordinates': Places[index]['coordinates'],
                                                          'timesOfWork': Places[index]['timesOfWork'],
                                                          'information': Places[index]['information'],
                                                        });
                                                      }
                                                      else if(PlacesList.any((item) => item['id'] == Places[index]['id']) == false && PlacesList.length == (3 * int.parse(planDetails[1]))){
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) => AlertDialog(
                                                            title: Text('Maximum picked sites reached'),
                                                            content: Text('You can select only 3 sites per day'),
                                                            actions: [
                                                              TextButton(
                                                                child: Text('OK'),
                                                                onPressed: () => Navigator.pop(context),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                      else{
                                                        PlacesList.removeWhere((item) => item['id'] == Places[index]['id']);
                                                      }
                                                    }
                                                    else{
                                                      if(PlacesList.any((item) => item['id'] == Places[index]['id']) == false){
                                                        PlacesList.add({
                                                          'id' : Places[index]['id'],
                                                          'name': Places[index]['name'],
                                                          'img': Places[index]['imgURL'],
                                                          'coordinates': Places[index]['coordinates'],
                                                          'timesOfWork': Places[index]['timesOfWork'],
                                                          'information': Places[index]['information'],
                                                        });
                                                      }
                                                      else{
                                                        PlacesList.removeWhere((item) => item['id'] == Places[index]['id']);
                                                      }
                                                    }
                                                    setState(() {

                                                    });
                                                    // print(PlacesList.contains(snapshot.data[index]['id']));
                                                  },
                                                  child: !PlacesList.any((item) => item['id'] == Places[index]['id'])? Text('Add'):Text('Added')
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        childCount: Places.length,
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                    child: Text(
                  'Sorry, There is no data yet.',
                  style: TextStyle(fontSize: 20),
                ));
              }
            }
            if (snapshot.hasError) {
              return Center(
                  child: Text('Please check your connection and try again',
                      style: TextStyle(fontSize: 20)));
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
