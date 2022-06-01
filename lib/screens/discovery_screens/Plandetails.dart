import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:untitled2/screens/discovery_screens/citiesData/FamousPlacesDetails.dart';

class Plandetails extends StatefulWidget {
  Plandetails({Key? key,required this.placeName}) : super(key: key);

  final placeName;
  @override
  _PlandetailsState createState() => _PlandetailsState();
}

class _PlandetailsState extends State<Plandetails> {


  int activeStep = 0;
  double _containerHeight = 255.0;
  int _itemsCount = 3;
  int hour = 7;

  @override
  Widget build(BuildContext context) {
    _itemsCount = widget.placeName.length;
    hour = 7;
    print(widget.placeName[0]);
    print(widget.placeName.length);
    return Container(

        decoration: BoxDecoration(
          image: DecorationImage(
            image:
            AssetImage('lib/img/pexels-mostafa-el-shershaby-3772630.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.darken),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height*0.02,
                    left: MediaQuery.of(context).size.width*0.4,
                    right: MediaQuery.of(context).size.width*0.4,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    height: 5,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: _itemsCount * (_containerHeight+_itemsCount+15),
                      child: ImageStepper(

                        lineColor: Colors.white,
                        lineLength: 245,
                        lineDotRadius: 3,
                        enableNextPreviousButtons: false,
                        steppingEnabled: false,
                        stepReachedAnimationEffect: Curves.ease,
                        scrollingDisabled: true,
                        images: numberOfSteps(),
                        //activeStep property set to activeStep variable defined above.
                        activeStep: activeStep,
                        // This ensures step-tapping updates the activeStep.
                        onStepReached: (index) {
                          setState(() {
                            activeStep = index;
                          });
                        },
                        direction: Axis.vertical,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            hour +=2;
                            return Container(
                            width: double.infinity,
                            height: _containerHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hour > 12?
                                    '${hour-12}:00 PM -- ${widget.placeName[index]['name']}':
                              '${hour}:00 AM -- ${widget.placeName[index]['name']}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Visit Duration: 2 hour',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${widget.placeName[index]['information']}',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Container(
                                    height: 1,
                                    color: Colors.black,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          children: [
                                            Icon(Icons
                                                .arrow_circle_right_outlined),
                                            Text('Add'),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Icon(Icons.access_time_outlined),
                                            Text('Open'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const FamousePlacesDetails(),
                                              settings: RouteSettings(
                                                  arguments: [
                                                    widget.placeName[index]['id'],
                                                    widget.placeName[index]['cityID'],
                                                  ]
                                              ),
                                            ));
                                      },
                                      child: Text('Read more'),
                                      style: ElevatedButton.styleFrom(
                                        onPrimary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(20.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 40,
                          ),
                          itemCount: _itemsCount,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
  }

  List<ImageProvider<dynamic>> numberOfSteps() {
    List<ImageProvider<dynamic>> li = [];
    for (int i = 0; i < _itemsCount; i++) {
      li.add(
        CachedNetworkImageProvider('${widget.placeName[i]['img']}'),
      );
    }
    print(li.length);
    return li;
  }
}
