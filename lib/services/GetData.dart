import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/services/authentication.dart';

var userdata = [];
var cityData = [];
var placesData = [];
var tourGuidersData = [];
var searchList = [];

getUser() async {
  Auth auth = Auth();
  var user = await auth.getCurrentUser();
  var userstore = FirebaseFirestore.instance.collection("users").doc(user?.uid);
  await userstore.get().then((value) {
    userdata = [];
    userdata.addAll([value.data()?['username'], value.data()?['photourl'],value.data()?['Email']]);
  });
  return userdata;
}

getCities() async {
  try {
  var city = FirebaseFirestore.instance.collection("Governments");
    await city.get().then((value) {
      cityData = [];
      for (var element in value.docs) {
        cityData.add(
            {
              'id': element.data()['id'],
              'name': element.data()['name'],
              'imgURL': element.data()['imgURL'],
            }
        );
      }
    });
  }
  catch (e) {
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
  var governID= [];
  placesData = [];
    places = FirebaseFirestore.instance.collection("Governments").doc(id).collection('info');
    await places.get().then((value) {
      placesData = [];
      for (var element in value.docs) {
        placesData.add(
          {
            'id' : element.data()['id'],
            'name': element.data()['name'],
            'imgURL' : element.data()['img'][0],
            'information': element.data()['information'],
          }
          //element.data(),
        );
      }
    });
  return placesData;
}

getPlacedata(var id) async {
  var places;
  var governID= [];
  placesData = [];
    places = FirebaseFirestore.instance.collection("Governments").doc(id[1]).collection('info').doc(id[0]);
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
  await userstore.where("work_site",isEqualTo: "$cityname").get().then((value) {
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
  var governID= [];
  searchList = [];
    await FirebaseFirestore.instance.collection("Governments").get().then((value) {
      for (var element in value.docs) {
        governID.add(
            {
              'id' : element.data()['id'],
            }
        );
        searchList.add(
            {
              'id' : element.data()['id'],
              'name': element.data()['name'],
            }
        );
      }
    });
    for(var index in governID){
      print(index['id']);
      await FirebaseFirestore.instance.collection("Governments").doc(index['id']).collection('info').get().then((value) {
        for (var element in value.docs) {
          searchList.add(
              {
                'id' : element.data()['id'],
                'name': element.data()['name'],
                'cityID': index['id'],
              }
          );
        }
      });
    }
    //print(placesData);
  // print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
  // print(searchList);
  return searchList..shuffle();
}

//
// getPlaces(var id) async {
//   var places = FirebaseFirestore.instance.collection("Governments").doc(id).collection('info');
//   await places.get().then((value) {
//     placesData = [];
//     for (var element in value.docs) {
//       placesData.add(
//         // {
//         //   'id' : element.data()['id'],
//         //   'name': element.data()['name'],
//         //   'imgURL' : element.data()['img'][0],
//         //   'information': element.data()['information'],
//         // }
//         element.data(),
//       );
//     }
//   });
//   return placesData;
// }















// getUser() async {
//   Auth auth = new Auth();
//   var user = await auth.getCurrentUser();
//   print(user?.uid);
//   var userstore = FirebaseFirestore.instance.collection("users").doc(user?.uid);
//   await userstore.get().then((value) {
//     userdata.addAll([value.data()?['username'],value.data()?['photourl']]);
//   });
//   return userdata;
// }
