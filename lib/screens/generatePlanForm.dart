import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/auth/secrets.dart';
import 'package:untitled2/screens/discovery_screens/famousPlacesForGenPlan.dart';
import 'package:untitled2/screens/maps/suggestionPlanMap.dart';

class generatePlanForm extends StatefulWidget {
  const generatePlanForm({Key? key}) : super(key: key);

  @override
  _generatePlanFormState createState() => _generatePlanFormState();
}

class _generatePlanFormState extends State<generatePlanForm> {
  final generationKey = GlobalKey<FormState>();
  final TextEditingController planName = TextEditingController();
  List<String> CitiesItems = ['Cairo','Luxor','Aswan','Giza'];
  List<String> StartPointItems = ['Your Current Location','Simulate your are in the City'];
  List<String> NumOfDaysItems = ['1','2','3'];
  List<String> StartDayItems = ['Saturday','Sunday','Monday','Tuesday','Wednesday','Thursday','Friday'];
  List<String> SortTypeItems = ['Optimal','Distance','Duration'];
  List<String> SelectedPlacesItems = ['Automatic','Choose Places'];
  String? selectedCityItem = 'Cairo';
  String? selectedStartPoint = 'Simulate your are in the City';
  String? selectedNumOfDays = '1';
  String? selectedStartDay = 'Saturday';
  String? selectedSortType = 'Optimal';
  String? selectedSelectedPlaces = 'Automatic';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(firstGenPlanEnter == false){
      getData();
    }
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      planName.text = prefs.getString('PlanName')?? '';
      selectedCityItem = prefs.getString('selectedCityItem') ?? 'Cairo';
      selectedStartPoint = prefs.getString('selectedStartPoint') ?? 'Simulate your are in the City';
      selectedNumOfDays = prefs.getString('selectedNumOfDays') ?? '1';
      selectedStartDay = prefs.getString('selectedStartDay') ?? 'Saturday';
      selectedSortType = prefs.getString('selectedSortType') ?? 'Optimal';
      selectedSelectedPlaces = prefs.getString('selectedSelectedPlaces') ?? 'Automatic';
    });

    print(prefs.getString('selectedCityItem'));
    print(prefs.getString('selectedStartPoint'));
    print( prefs.getString('selectedNumOfDays'));
    print( prefs.getString('selectedStartDay'));
    print(prefs.getString('selectedSortType'));
    print(prefs.getString('selectedSelectedPlaces'));
    print('suc');
  }
  @override
  Widget build(BuildContext context) {
    print(firstGenPlanEnter);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              PlacesList = [];
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.keyboard_arrow_left,
              size: 45,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: generationKey,
                child: ListView(
                  children: [
                    Text(
                      "Enter Plan Name",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: planName,
                      onChanged: (val) {
                        //email = val;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is Required";
                        }
                        return null;
                      },
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                          hintText: "Write plan name",
                          hintStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                          fillColor: Colors.white,
                          filled: true),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      "Enter Governorate Name",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      padding: EdgeInsets.only(left: 10),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedCityItem,
                          items: CitiesItems
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCityItem = newValue!;
                              PlacesList.clear();
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      "Sort by",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      padding: EdgeInsets.only(left: 10),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedSortType,
                          items: SortTypeItems
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedSortType = newValue!;
                              PlacesList.clear();
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      "Starting Point",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      padding: EdgeInsets.only(left: 10),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedStartPoint,
                          items: StartPointItems
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedStartPoint = newValue!;
                              PlacesList.clear();
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    selectedSelectedPlaces != "Choose Places"?
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Number Of Days",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width*0.4,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                padding: EdgeInsets.only(
                                  left: 10,
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedNumOfDays,
                                    items: NumOfDaysItems
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedNumOfDays = newValue!;
                                        PlacesList.clear();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Starting Day",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width*0.44,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                padding: EdgeInsets.only(
                                    left: 10,
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedStartDay,
                                    items: StartDayItems
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedStartDay = newValue!;
                                        PlacesList.clear();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ):
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Number Of Days",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  'Number of days is gonna be based on number of places you select',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Starting Day",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width*0.44,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                padding: EdgeInsets.only(
                                  left: 10,
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedStartDay,
                                    items: StartDayItems
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedStartDay = newValue!;
                                        PlacesList.clear();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       "Starting Day",
                    //       style: TextStyle(
                    //         fontSize: 20,
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       height: 10,
                    //     ),
                    //     Container(
                    //       width: MediaQuery.of(context).size.width*0.44,
                    //       decoration: BoxDecoration(
                    //           border: Border.all(),
                    //           borderRadius: BorderRadius.circular(10)
                    //       ),
                    //       padding: EdgeInsets.only(
                    //         left: 10,
                    //       ),
                    //       child: DropdownButtonHideUnderline(
                    //         child: DropdownButton<String>(
                    //           value: selectedStartDay,
                    //           items: StartDayItems
                    //               .map<DropdownMenuItem<String>>((String value) {
                    //             return DropdownMenuItem<String>(
                    //               value: value,
                    //               child: Text(
                    //                 value,
                    //                 style: TextStyle(fontSize: 20),
                    //               ),
                    //             );
                    //           }).toList(),
                    //           onChanged: (String? newValue) {
                    //             setState(() {
                    //               selectedStartDay = newValue!;
                    //               PlacesList.clear();
                    //             });
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 10,),
                    Text(
                      "Pick Places",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      padding: EdgeInsets.only(left: 10),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedSelectedPlaces,
                          items: SelectedPlacesItems
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedSelectedPlaces = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                    if(selectedSelectedPlaces == "Choose Places")
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: PlacesList.length > 0?
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            ListView.separated(
                              shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.s,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                '${PlacesList[index]['img']}'),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        height: 100,
                                        width: 100,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${PlacesList[index]['name']}',
                                          style: TextStyle(
                                              fontSize: 20
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                separatorBuilder: (context, index) => Container(
                                  height: 1,
                                  width: 50,
                                  color: Colors.black,
                                ),
                                itemCount: PlacesList.length),
                            ElevatedButton(
                              style:
                              ElevatedButton.styleFrom(
                                primary: Colors.white,
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      5.0),
                                  side: const BorderSide(
                                      width: 1),
                                ),
                              ),
                              onPressed: () async {
                                String id = 'null';
                                if(selectedCityItem!.toLowerCase() == 'cairo'){
                                  id = 'MqtWts6maiQC6D7tQcoI';
                                }
                                else if(selectedCityItem!.toLowerCase() == 'giza'){
                                  id = 'WBoo3QdcsD2j1mvw8Cfd';
                                }
                                else if(selectedCityItem!.toLowerCase() == 'aswan'){
                                  id = 'ZqbIIznmmjgVRwYKJU1b';
                                }
                                else{
                                  id = 'wsnG3ogBp0QVaOLn1RlV';
                                }

                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setString('PlanName', planName.text);
                                prefs.setString('selectedCityItem', selectedCityItem!);
                                prefs.setString('selectedStartPoint', selectedStartPoint!);
                                prefs.setString('selectedNumOfDays', selectedNumOfDays!);
                                prefs.setString('selectedStartDay', selectedStartDay!);
                                prefs.setString('selectedSortType', selectedSortType!);
                                prefs.setString('selectedSelectedPlaces', selectedSelectedPlaces!);
                                firstGenPlanEnter = false;


                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => famousPlacesForGenPlan(),
                                        settings: RouteSettings(
                                          arguments: [id,selectedNumOfDays,selectedStartDay,selectedSelectedPlaces],
                                        )
                                    ));
                              },
                              child: const Text('Add Places'),
                            ),
                          ],
                        ),
                      ):
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                          child: Center(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Nothing selected yet'),
                              ElevatedButton(
                                style:
                                ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shape:
                                  RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        5.0),
                                    side: const BorderSide(
                                        width: 1),
                                  ),
                                ),
                                onPressed: () async {
                                  String id = 'null';
                                  if(selectedCityItem!.toLowerCase() == 'cairo'){
                                    id = 'MqtWts6maiQC6D7tQcoI';
                                  }
                                  else if(selectedCityItem!.toLowerCase() == 'giza'){
                                    id = 'WBoo3QdcsD2j1mvw8Cfd';
                                  }
                                  else if(selectedCityItem!.toLowerCase() == 'aswan'){
                                    id = 'ZqbIIznmmjgVRwYKJU1b';
                                  }
                                  else{
                                    id = 'wsnG3ogBp0QVaOLn1RlV';
                                  }

                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setString('PlanName', planName.text);
                                  prefs.setString('selectedCityItem', selectedCityItem!);
                                  prefs.setString('selectedStartPoint', selectedStartPoint!);
                                  prefs.setString('selectedNumOfDays', selectedNumOfDays!);
                                  prefs.setString('selectedStartDay', selectedStartDay!);
                                  prefs.setString('selectedSortType', selectedSortType!);
                                  prefs.setString('selectedSelectedPlaces', selectedSelectedPlaces!);
                                  firstGenPlanEnter = false;


                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => famousPlacesForGenPlan(),
                                          settings: RouteSettings(
                                            arguments: [id,selectedNumOfDays,selectedStartDay,selectedSelectedPlaces],
                                          )
                                      ));
                                },
                                child: const Text('Add Places'),
                              ),

                            ],
                          ),)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: ElevatedButton(
                        style:
                        ElevatedButton.styleFrom(
                          //primary: Colors.grey,
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                                5.0),
                          ),
                        ),
                        onPressed: () {
                          if(generationKey.currentState!.validate()){
                            String id = 'null';
                            if(selectedCityItem!.toLowerCase() == 'cairo'){
                              id = 'MqtWts6maiQC6D7tQcoI';
                            }
                            else if(selectedCityItem!.toLowerCase() == 'giza'){
                              id = 'WBoo3QdcsD2j1mvw8Cfd';
                            }
                            else if(selectedCityItem!.toLowerCase() == 'aswan'){
                              id = 'ZqbIIznmmjgVRwYKJU1b';
                            }
                            else{
                              id = 'wsnG3ogBp0QVaOLn1RlV';
                            }
                            firstGenPlanEnter = true;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => suggestionPlanMap(
                                      savedPlan: false,
                                      planName : planName.text,
                                      cityid: id,
                                      numberOfSights: 3 * int.parse(selectedNumOfDays!),
                                      numofDays: int.parse(selectedNumOfDays!),
                                      day: selectedStartDay,SortType: selectedSortType!,
                                      StartPoint: selectedStartPoint!,
                                      pickedPlaces: selectedSelectedPlaces!),
                                )
                            );
                          }
                          print('44444444444444444444444444444444444444444');
                          print(planName.text);
                        },
                        child: const Text(
                          'Generate Plan',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20
                          ),
                        ),
                      ),
                    ),
                  ],

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
