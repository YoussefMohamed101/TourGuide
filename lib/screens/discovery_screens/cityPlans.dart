import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled2/screens/maps/ShowMap.dart';
import 'package:untitled2/screens/maps/suggestionPlanMap.dart';

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

    numberOfSights = 3 * numberOfDays;
    List<imgModel> imgDetails = [
      imgModel(
          imgURl: 'lib/img/pexels-mostafa-el-shershaby-3772630.png',
          numOfDays: '${numberOfDays} ${strDays}',
          numOfSights: '${numberOfSights} sights',
          description: 'Explore ${city[1]} in ${numberOfDays} ${strDays}, visit most popular places'),
      imgModel(
          imgURl: 'lib/img/pexels-mostafa-el-shershaby-37726330.png',
          numOfDays: '${numberOfDays} ${strDays}',
          numOfSights: '${numberOfSights} sights',
          description: 'Explore ${city[1]} in ${numberOfDays} ${strDays}, visit most popular places'),
    ];
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: numberOfDays == 4
                        ? Color.fromRGBO(249, 168, 38, 1)
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: numberOfDays == 4
                              ? Colors.transparent
                              : Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: Size(80, 40),
                  ),
                  onPressed: () {
                    setState(() {
                      numberOfDays = 4;
                      strDays = 'Days';
                    });
                  },
                  child: Text(
                    '4 Days',
                    style: TextStyle(
                      color: numberOfDays == 4 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(
                18.0,
              ),
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) =>
                    buildPlansItem(imgDetails[index],city[0]),
                separatorBuilder: (context, index) => SizedBox(
                  height: 20,
                ),
                itemCount: imgDetails.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget buildPlansItem(imgModel img, String city) => Stack(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.bottomLeft,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('${img.imgURl}'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.15), BlendMode.darken),
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 10.0,
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.white.withOpacity(0.8),
                        size: 18,
                      ),
                      Text(
                        '${img.numOfDays}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.remove_red_eye,
                        color: Colors.white.withOpacity(0.8),
                        size: 18,
                      ),
                      Text(
                        '${img.numOfSights}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0,left: 8.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                '${img.description}',
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
            child: InkWell(onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => suggestionPlanMap(cityid: city,numberOfSights: numberOfSights,),
                  )
              );
            },
              splashColor: Colors.black12,
              highlightColor: Colors.black12,
            )
        ),
      ),
    ],
  );
}
