import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled2/auth/secrets.dart';
import 'package:untitled2/screens/fixedSuggestionPlans.dart';
import 'package:untitled2/screens/maps/suggestionPlanMap.dart';
import 'package:untitled2/services/GetData.dart';
import 'package:path/path.dart' as p;

class myPlans extends StatefulWidget {
  const myPlans({Key? key}) : super(key: key);

  @override
  State<myPlans> createState() => _myPlansState();
}

class _myPlansState extends State<myPlans> {
  File? _image;
  XFile? photo;
  File? imageTemporary;
  String? fileName;

  bool showChangeName = false;
  bool showChangePassword = false;
  bool securePass = true;

  final _changeName = GlobalKey<FormState>();
  final _changePassword = GlobalKey<FormState>();
  final TextEditingController _firstNameTextController =
      TextEditingController();
  final TextEditingController _lastNameTextController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  Future getImagefromcamera() async {
    photo = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 25);
    imageTemporary = File(photo!.path);
    setState(() {
      _image = imageTemporary;
    });
    fileName = p.basename(photo!.path);
    updatePhoto();
  }

  Future getImagefromGallery() async {
    photo = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 25);
    imageTemporary = File(photo!.path);
    setState(() {
      _image = imageTemporary;
    });
    fileName = p.basename(photo!.path);
    updatePhoto();
  }

  Future<void> updatePhoto() async {
    var user = FirebaseAuth.instance.currentUser;
    var imageurl;
    try {
      var ref = FirebaseStorage.instance
          .ref('Images')
          .child('Users')
          .child('${user!.uid}')
          .child('$fileName');
      await ref.putFile(imageTemporary!);
      imageurl = await ref.getDownloadURL();
    } on FirebaseAuthException catch (e) {
      print('asdasd');
      print(e.toString());
    }

    await FirebaseFirestore.instance.collection("users").doc(user!.uid).update({
      "photourl": imageurl,
    });

    setState(() {});
  }

  Future<void> updateName(String firstName, String lastName) async {
    var user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection("users").doc(user!.uid).update({
      "firstName": firstName,
      "lastName": lastName,
    }).then((value) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Name changed successfully'),
          content: Text('Name changed successfully'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  showChangeName = false;
                });
              },
            ),
          ],
        ),
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Name changed Failed'),
          content: Text('Failed changing Name, try again later'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  showChangeName = false;
                });
              },
            ),
          ],
        ),
      );
    });

    setState(() {});
  }

  void changePassword(String currentPassword, String newPassword) async {
    final user = await FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: userdata23[3], password: currentPassword);

    user!.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Password changed successfully'),
            content: Text('Your Password changed successfully'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    showChangePassword = false;
                    _oldPasswordController.clear();
                    _newPasswordController.clear();
                  });
                },
              ),
            ],
          ),
        );
      }).catchError((error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Password changed Failed'),
            content: Text('Failed changing Password, try again later'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    showChangePassword = false;
                    _oldPasswordController.clear();
                    _newPasswordController.clear();
                  });
                },
              ),
            ],
          ),
        );
      });
    }).catchError((err) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('The password is invalid'),
          content: Text('Check your old password and try again'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  showChangePassword = false;
                  _oldPasswordController.clear();
                  _newPasswordController.clear();
                });
              },
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        userdata23[2],
                      ),
                      fit: BoxFit.fill),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
                alignment: Alignment.center,
                child: Text(
                  '${userdata23[0]} ${userdata23[1]}',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )),
            SizedBox(
              height: 50,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'My plans',
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
            ),
            SizedBox(
              height: 50,
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(userdata23[4])
                      .collection('userPlans')
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if(snapshot.data.docs.length == 0){
                        return Center(
                            child: Text(
                                'There is no plans right now',
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 150,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              '${snapshot.data.docs[index].data()['imgUrl']}'),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
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
                                        MediaQuery.of(context).size.width * 0.02,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical:
                                              MediaQuery.of(context).size.width *
                                                  0.03,
                                            ),
                                            child: Text(
                                              '${snapshot.data.docs[index].data()['title']}',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    //primary: Colors.grey,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(30.0),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    if(snapshot.data.docs[index].data()['Generated'] == 'true'){
                                                      var data = await showGeneratedPlanDetails(snapshot.data.docs[index].data()['title'],userdata23[4]);
                                                      // log(snapshot.data.docs[index].data()['Generated'].toString());
                                                      print(data);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => suggestionPlanMap(
                                                              savedPlan: true,
                                                              planName: snapshot.data.docs[index].data()['title'],
                                                              cityid: 'sadasd',
                                                              numberOfSights: 4,
                                                              day: 'fghfg',
                                                              numofDays: 3,
                                                              SortType: '',
                                                              StartPoint: '',
                                                              pickedPlaces: '',
                                                            ),
                                                          )
                                                      );

                                                    }
                                                    else{
                                                      var data = await showPlanDetails(snapshot.data.docs[index].data()['id'], snapshot.data.docs[index].data()['planID']);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => fixedSuggestionPlans(planDetail: data[0]),
                                                          )
                                                      );
                                                    }
                                                  },
                                                  child: const Text(
                                                    'View',
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
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    primary: Colors.white,
                                                    onPrimary: Colors.black,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(30.0),
                                                      side:
                                                      const BorderSide(width: 1),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                        await FirebaseFirestore.instance
                                                            .collection('users')
                                                            .doc(userdata23[4])
                                                            .collection('userPlans').where('planID',isEqualTo: '${snapshot.data.docs[index].data()['planID']}')
                                                            .get()
                                                            .then((value) async {
                                                          for(var item in value.docs){
                                                            print(item.id);
                                                            await FirebaseFirestore.instance
                                                                .collection('users')
                                                                .doc(userdata23[4])
                                                                .collection('userPlans')
                                                                .doc(item.id)
                                                                .delete();
                                                          }

                                                        });
                                                  },
                                                  child: Text('Delete'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          separatorBuilder: (context, index) => Container(),
                          itemCount: snapshot.data.docs.length);
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
