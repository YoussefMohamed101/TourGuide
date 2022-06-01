import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';

class IconStepperDemo extends StatefulWidget {
  @override
  _IconStepperDemo createState() => _IconStepperDemo();
}

class _IconStepperDemo extends State<IconStepperDemo> {
  // THE FOLLOWING TWO VARIABLES ARE REQUIRED TO CONTROL THE STEPPER.
  int activeStep = 0; // Initial step set to 5.

  int upperBound = 6; // upperBound MUST BE total number of icons minus 1.

  double _containerHeight = 255.0;
  int _itemsCount = 3;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('IconStepper Example'),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height - 20.0,
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
              height: MediaQuery.of(context).size.height - 20.0,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: _itemsCount * (_containerHeight+_itemsCount+15),
                          child: ImageStepper(
                            lineLength: 245,
                            enableNextPreviousButtons: false,
                            steppingEnabled: false,
                            stepReachedAnimationEffect: Curves.ease,
                            scrollingDisabled: true,
                            images: nextButton(),
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
                            padding: const EdgeInsets.symmetric(vertical: 35.0),
                            child: ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => Container(
                                width: double.infinity,
                                height: _containerHeight,
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '9:00 AM -- asdasdasdasdasdas Temple',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Visit Duration: 2 hour',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'afja;slkfjsdla;kfj;laskdfj;laskdfj;alsadas;djas;ldkjsa;lkf;lsadkfha;sldkfjsa;ldfjsd;lfjaks;ljfs;alskjf;asldkfjas;ldkfj;lasdkfj;lk',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        height: 1,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        height: 10,
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
                                          onPressed: () {},
                                          child: Text('Read more'),
                                          style: ElevatedButton.styleFrom(
//primary: Colors.grey,
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
                              ),
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
          ),
        ),
      ),
    );
  }

  List<ImageProvider<dynamic>> nextButton() {
    List<ImageProvider<dynamic>> li = [];
    for (int i = 0; i < _itemsCount; i++) {
      print(i);
      li.add(
        AssetImage('lib/img/place_holder.jpg'),
      );
    }
    print(li.length);
    return li;
  }

  /// Returns the next button.
  Widget nexttButton() {
    return ElevatedButton(
      onPressed: () {
        // Increment activeStep, when the next button is tapped. However, check for upper bound.
        if (activeStep < upperBound) {
          setState(() {
            activeStep++;
          });
        }
      },
      child: Text('Next'),
    );
  }

  /// Returns the previous button.
  Widget previousButton() {
    return ElevatedButton(
      onPressed: () {
        // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
        if (activeStep > 0) {
          setState(() {
            activeStep--;
          });
        }
      },
      child: Text('Prev'),
    );
  }

  /// Returns the header wrapping the header text.
  Widget header() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              headerText(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Returns the header text based on the activeStep.
  String headerText() {
    switch (activeStep) {
      case 1:
        return 'Preface';

      case 2:
        return 'Table of Contents';

      case 3:
        return 'About the Author';

      case 4:
        return 'Publisher Information';

      case 5:
        return 'Reviews';

      case 6:
        return 'Chapters #1';

      default:
        return 'Introduction';
    }
  }
}

// header(),
// Expanded(
// child: FittedBox(
// child: Center(
// child: Text('$activeStep'),
// ),
// ),
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// previousButton(),
// nextButton(),
// ],
// ),
