import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled2/services/GetData.dart';

class personalGuidersCity extends StatelessWidget {
  //const personalGuidersCity({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var cityTourGuider = (ModalRoute.of(context)!.settings.arguments as String);
    late final Future TourGuidersData = gettourGuiders('$cityTourGuider');
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
              color: const Color.fromRGBO(249, 168, 38, 1),
              size: 50,
            )),
        title: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: const Text('Tour guiders available'),
        ),
        actions: [],
      ),
      body: FutureBuilder(
          future: TourGuidersData,
          builder: (context, AsyncSnapshot snapshot) {
            if(snapshot.hasData){
              return CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) => Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height * 0.04,
                              horizontal:
                              MediaQuery.of(context).size.width * 0.001,
                            ),
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                side: BorderSide(),
                                borderRadius:
                                BorderRadius.all(Radius.circular(12)),
                              ),
                              color: const Color.fromRGBO(240, 240, 240, 1),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                '${snapshot.data[index]['imgURL']}',
                                                fit: BoxFit.fill,
                                                height: 75,
                                                width: 75,
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${snapshot.data[index]['name']}',
                                                    maxLines: 2,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                        0.01,
                                                  ),
                                                  const Text(
                                                    'Tour Guide',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        //color: Color.fromRGBO(7, 79, 98, 1),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color.fromRGBO(7, 82, 102, 1),
                                              const Color.fromRGBO(4, 42, 52, 1),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(12)),
                                      height: MediaQuery.of(context).size.height *
                                          0.13,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width:
                                          MediaQuery.of(context).size.width *
                                              0.22,
                                          height:
                                          MediaQuery.of(context).size.height *
                                              0.13,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'D.O.B',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color.fromRGBO(
                                                          112, 112, 112, 1),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                        0.008,
                                                  ),
                                                  Text(
                                                    '${snapshot.data[index]['DOB']}',
                                                    maxLines: 2,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: const Color.fromRGBO(
                                                          112, 112, 112, 1),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Work site',
                                                    maxLines: 2,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: const Color.fromRGBO(
                                                          112, 112, 112, 1),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                        0.008,
                                                  ),
                                                  Text(
                                                    '${snapshot.data[index]['work_site']}',
                                                    maxLines: 2,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: const Color.fromRGBO(
                                                          112, 112, 112, 1),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 1,
                                          height:
                                          MediaQuery.of(context).size.height *
                                              0.13,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width:
                                          MediaQuery.of(context).size.width *
                                              0.34,
                                          height:
                                          MediaQuery.of(context).size.height *
                                              0.13,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Degree',
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color.fromRGBO(
                                                          112, 112, 112, 1),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                        0.007,
                                                  ),
                                                  Text(
                                                    '${snapshot.data[index]['degree']}',
                                                    maxLines: 3,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color.fromRGBO(
                                                          112, 112, 112, 1),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'ID Num',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color.fromRGBO(
                                                          112, 112, 112, 1),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${snapshot.data[index]['id_number']}',
                                                    maxLines: 1,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: const Color.fromRGBO(
                                                          112, 112, 112, 1),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 1,
                                          height:
                                          MediaQuery.of(context).size.height *
                                              0.13,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width:
                                          MediaQuery.of(context).size.width *
                                              0.3,
                                          height:
                                          MediaQuery.of(context).size.height *
                                              0.13,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                '${snapshot.data[index]['phone_number']}',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: const Color.fromRGBO(
                                                      112, 112, 112, 1),
                                                ),
                                              ),
                                              Text(
                                                '${snapshot.data[index]['email']}',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: const Color.fromRGBO(
                                                      112, 112, 112, 1),
                                                ),
                                              ),
                                              const Text(
                                                'www.website.com',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Color.fromRGBO(
                                                      112, 112, 112, 1),
                                                ),
                                              ),
                                            ],
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
                      childCount: snapshot.data.length,
                    ),
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator(),);
          }),
    );
  }
}
