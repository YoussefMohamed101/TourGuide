import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled2/screens/discovery_screens/citiesData/FamousPlacesDetails.dart';
import 'package:untitled2/services/GetData.dart';

class mostFamousePlaces extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cityId = (ModalRoute.of(context)!.settings.arguments as String);
    late final Future cityPlaces = getPlaces(cityId);
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
            child: IconButton(onPressed: () {}, icon: const Icon(
              Icons.search,
              color: Color.fromRGBO(249, 168, 38, 1),
              size: 40,)),
          ),
        ],
      ),
      body: FutureBuilder(
          future: cityPlaces,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length != 0) {
                return CustomScrollView(
                  slivers: <Widget>[
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
                                            '${snapshot.data[index]['img'][0]}'),
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
                                            '${snapshot.data[index]['name']}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          '${snapshot.data[index]['information']}',
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
                                                              arguments: snapshot.data[index],
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
                                                    primary: Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                      side: const BorderSide(
                                                          width: 1),
                                                    ),
                                                  ),
                                                  onPressed: () {},
                                                  child: const Text('add'),
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
                        childCount: snapshot.data.length,
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
