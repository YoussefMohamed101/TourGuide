import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/services/authentication.dart';
import 'package:url_launcher/url_launcher.dart';

var userdata = [];
var userid;
var cityData = [];
var placesData = [];
var tourGuidersData = [];
var searchList = [];
var cityCordData = [];

getUser() async {
  Auth auth = Auth();
  var user = await auth.getCurrentUser();
  // var userstore = FirebaseFirestore.instance.collection("users").doc(user?.uid);
  // await userstore.get().then((value) {
  //   userdata = [];
  //   userdata.addAll(
  //       [value.data()?['firstName'],value.data()?['lastName'], value.data()?['photourl'],value.data()?['Email']]);
  // });
  userid = user!.uid;
  return userid;
}

getCities() async {
  try {
    var city = FirebaseFirestore.instance.collection("Governments");
    await city.get().then((value) {
      cityData = [];
      for (var element in value.docs) {
        cityData.add({
          'id': element.data()['id'],
          'name': element.data()['name'],
          'imgURL': element.data()['imgURL'],
        });
      }
    });
  } catch (e) {
    print('**************************************');
    print(e.toString());
  }
  return cityData;
}

getCitydata(var id) async {
  var city = FirebaseFirestore.instance.collection("Governments").doc('$id');
  await city.get().then((value) {
    cityData = [];
    cityData.add(
      value.data(),
    );
  });
  return cityData;
}

getPlaces(var id) async {
  var places;
  var governID = [];
  placesData = [];
  places = FirebaseFirestore.instance
      .collection("Governments")
      .doc(id)
      .collection('info');
  await places.get().then((value) {
    placesData = [];
    for (var element in value.docs) {
      placesData.add({
        'id': element.data()['id'],
        'name': element.data()['name'],
        'imgURL': element.data()['img'][0],
        'information': element.data()['information'],
        'coordinates': element.data()['coordinates'],
        'timesOfWork': element.data()['timesOfWork'],
      }
          //element.data(),
          );
    }
  });
  return placesData;
}

// getPlaces(var id) async {
//   var places;
//   var governID= [];
//   placesData = [];
//   places = FirebaseFirestore.instance.collection("Governments").doc(id).collection('info');
//   await places.get().then((value) {
//     placesData = [];
//     for (var element in value.docs) {
//       placesData.add(
//           {
//             'id' : element.data()['id'],
//             'name': element.data()['name'],
//             'imgURL' : element.data()['img'][0],
//             'information': element.data()['information'],
//             'coordinates': element.data()['coordinates'],
//             'timesOfWork': element.data()['timesOfWork'],
//           }
//         //element.data(),
//       );
//     }
//   });
//   return placesData;
// }

getPlacedata(var id) async {
  var places;
  var governID = [];
  placesData = [];
  places = FirebaseFirestore.instance
      .collection("Governments")
      .doc(id[1])
      .collection('info')
      .doc(id[0]);
  await places.get().then((value) {
    placesData = [];
    placesData.add(
      value.data(),
    );
  });
  return placesData;
}

gettourGuiders(var cityname) async {
  var userstore = FirebaseFirestore.instance.collection("tourGuiders");
  await userstore
      .where("work_site", isEqualTo: "$cityname")
      .get()
      .then((value) {
    tourGuidersData = [];
    for (var element in value.docs) {
      tourGuidersData.add(
        element.data(),
      );
    }
  });
  print(tourGuidersData);
  return tourGuidersData;
}

searchEngine() async {
  var governID = [];
  searchList = [];
  await FirebaseFirestore.instance
      .collection("Governments")
      .get()
      .then((value) {
    for (var element in value.docs) {
      governID.add({
        'id': element.data()['id'],
      });
      searchList.add({
        'id': element.data()['id'],
        'name': element.data()['name'],
        'coordinates': element.data()['coordinates'],
      });
    }
  });
  for (var index in governID) {
    print(index['id']);
    await FirebaseFirestore.instance
        .collection("Governments")
        .doc(index['id'])
        .collection('info')
        .get()
        .then((value) {
      for (var element in value.docs) {
        searchList.add({
          'id': element.data()['id'],
          'name': element.data()['name'],
          'cityID': index['id'],
          'coordinates': element.data()['coordinates'],
        });
      }
    });
  }
  //print(placesData);
  // print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
  // print(searchList);
  return searchList..shuffle();
}

getCityCoordinates(var id) async {
  var governID = [];
  var places = [];
  try {
    var city = FirebaseFirestore.instance.collection("Governments");
    await city.where('id', isEqualTo: id).get().then((value) {
      cityCordData = [];
      for (var element in value.docs) {
        governID.add({
          'id': element.data()['id'],
          'coordinates': element.data()['coordinates'],
          'name': element.data()['name'],
        });
      }
    });

    await city
        .doc('${governID[0]['id']}')
        .collection('info')
        .get()
        .then((value) {
      for (var item in value.docs) {
        places.add({
          'id': item.data()['id'],
          'coordinates': item.data()['coordinates'],
          'name': item.data()['name'],
          'img': item.data()['img'][0],
          'cityID': governID[0]['id'],
          'information': item.data()['information'],
          'timesOfWork': item.data()['timesOfWork'],
        });
      }
    });
  } catch (e) {
    print('**************************************');
    print(e.toString());
  }

  cityCordData.add({'city': governID, 'places': places});
  return cityCordData;
}

displayPlans(cityId, numOfDays) async {
  var retriveData = [];
  try {
    var gov =
        FirebaseFirestore.instance.collection('Governments').doc('$cityId');

    await gov
        .collection('plans')
        .where('numOfDays', isEqualTo: numOfDays)
        .get()
        .then((value) {
      for (var item in value.docs) {
        retriveData.add(item.data());
      }
    });
    if (retriveData.isEmpty) {
      return [];
    }
    return retriveData;
  } catch (e) {
    print(e);
  }
}

showPlanDetails(cityId, planId) async {
  try {
    var data = [];
    var gov = await FirebaseFirestore.instance
        .collection('Governments')
        .doc('$cityId')
        .collection('plans')
        .doc(planId)
        .get()
        .then((value) {
      data.addAll({value.data()});
    });
    if (data.isEmpty) {
      return [];
    } else {
      return data;
    }
  } catch (e) {
    print(e);
  }
}

showGeneratedPlanDetails(title, userID) async {
  try {
    var data = [];
    var gov = await FirebaseFirestore.instance
        .collection('users')
        .doc('$userID')
        .collection('userPlans')
        .where('title', isEqualTo: title)
        .get()
        .then((value) {
          for(var item in value.docs){
            data.addAll(
                {item.data()['Data']}
            );
            break;
          }
    });
    if (data.isEmpty) {
      return [];
    } else {
      return data[0];
    }
  } catch (e) {
    print(e);
  }
}

Future<void> launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $url';
  }
}