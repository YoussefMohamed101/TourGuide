import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled2/services/authentication.dart';

var userdata = [];
var cityData = [];
var placesData = [];

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
  var city = FirebaseFirestore.instance.collection("Governments");
  await city.get().then((value) {
    cityData = [];
    for (var element in value.docs) {
      cityData.add(
      {
        'id' : element.data()['id'],
        'name': element.data()['name'],
        'imgURL' : element.data()['imgURL'],
      }
      );
    }
  });
  return cityData;
}

getPlaces(var id) async {
  var places;
  var governID= [];
  placesData = [];
  if (id == 0){
    await FirebaseFirestore.instance.collection("Governments").get().then((value) {
      for (var element in value.docs) {
        governID.add(
            {
                'id' : element.data()['id'],
            }
        );
        placesData.add(
            {
              'id' : element.data()['id'],
              'name': element.data()['name'],
              'imgURL' : element.data()['imgURL'],
            }
        );
      }
    });
    print(governID);
    for(var index in governID){
       print(index['id']);
      await FirebaseFirestore.instance.collection("Governments").doc(index['id']).collection('info').limit(5).get().then((value) {
        for (var element in value.docs) {
          placesData.add(
              {
                'id' : element.data()['id'],
                'name': element.data()['name'],
                'imgURL' : element.data()['img'][0],
              }
          );
        }
      });
    }
    //print(placesData);
  }
  else{
    places = FirebaseFirestore.instance.collection("Governments").doc(id).collection('info');
    await places.get().then((value) {
      placesData = [];
      for (var element in value.docs) {
        placesData.add(
          // {
          //   'id' : element.data()['id'],
          //   'name': element.data()['name'],
          //   'imgURL' : element.data()['img'][0],
          //   'information': element.data()['information'],
          // }
          element.data(),
        );
      }
    });
  }
  print('**********************************');
  print(placesData);
  return placesData;
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
