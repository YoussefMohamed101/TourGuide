import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled2/screens/discovery_screens/citiesData/FamousPlacesDetails.dart';
import 'package:untitled2/screens/discovery_screens/citiesData/city_descripton.dart';
import 'package:untitled2/screens/discovery_screens/citiesData/mostFamousPlaces.dart';
import 'package:untitled2/services/GetData.dart';

class searchScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    late final Future CityData = getCities();
    late final Future placesData = getPlaces(0);
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
              ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.keyboard_arrow_left,
              size: 50,
            )),
        title: Container(
          height: MediaQuery.of(context).size.height*0.06,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              20.0,
            ),
            border: Border.all(
              color: Colors.black,
            ),
          ),
          child: TextField(
            cursorColor: Colors.black,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontSize: 18,
            ),
            onChanged: (String value) {
              print(value);
            },
            decoration: InputDecoration(
              hintText: 'Where do you want to go?',
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.grey,
                height: MediaQuery.of(context).size.height*0.001,
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: CityData,
        builder: (context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            return Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.03,
                ),

                Expanded(
                  child: CustomScrollView(
                          slivers: <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                    (context, index) => Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width*0.02,
                                    vertical: MediaQuery.of(context).size.height*0.01,
                                  ),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height*0.045,
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context).size.height*0.01,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on_outlined,
                                                  color: Colors.grey,
                                                  size: 30,
                                                  // color: Color.fromRGBO(249, 168, 38, 1),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width*0.05,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${snapshot.data[index]['name']}',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 25,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.grey
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox.expand(
                                          child: Material(
                                              type: MaterialType.transparency,
                                              child: InkWell(onTap: () {
                                                // if(
                                                // snapshot.data[index]['name'] == 'Cairo'||
                                                //     snapshot.data[index]['name'] == 'Giza'||
                                                //     snapshot.data[index]['name'] == 'Luxor'||
                                                //     snapshot.data[index]['name'] == 'Aswan'
                                                // ){
                                                //   Navigator.push(
                                                //       context,
                                                //       MaterialPageRoute(
                                                //         builder: (context) => city_preview(),
                                                //         settings: RouteSettings(
                                                //           arguments: snapshot.data[index],
                                                //         ),
                                                //       ));
                                                // }
                                                // else{
                                                //   print(snapshot.data[index]);
                                                //   // Navigator.push(
                                                //   //     context,
                                                //   //     MaterialPageRoute(
                                                //   //       builder: (context) => mostFamousePlaces(),
                                                //   //       settings: RouteSettings(
                                                //   //         arguments: snapshot.data[index],
                                                //   //       ),
                                                //   //     ));
                                                //
                                                // }
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => city_preview(),
                                                      settings: RouteSettings(
                                                        arguments: snapshot.data[index],
                                                      ),
                                                    ));
                                              },)
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
                        ),
                ),
              ],
            );
          }
          return const Center(child: const CircularProgressIndicator(),);
        }
      ),
    );
  }
}
