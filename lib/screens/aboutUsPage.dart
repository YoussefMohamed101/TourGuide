import 'package:flutter/material.dart';

class aboutUsPage extends StatelessWidget {
  const aboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.keyboard_arrow_left,
              size: 45,
            )),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              'Privacy',
              style: TextStyle(fontSize: 30),
            ),
            Text(
              'When you open an app, it may store or retrieve information on your device, usually in the form of SDKs. This information might be about you, your preferences or your device and is mostly used to make the app work as you expect it to. The information does not usually directly identify you, but it can give you a more personalized app experience. Because we respect your right to privacy, you can choose not to allow some types of SDKs. Click on the different category headings to find out more and change our default settings. However, blocking some types of SDKs may impact your experience of the app and the services we are able to offer.',
              style: TextStyle(
                  fontSize: 18
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.02,
            ),
            Text(
              'About us',
              style: TextStyle(fontSize: 30),
            ),
            Text(
              'tripGuide  application is a guide to the tourist and archaeological sites in Egypt aims to disseminate information about the beauty of monuments and tourist places in Egypt and their places,dates of visit to those places and making plans for visiting multiple places.You can contact us by calling the hot line of 19777 or visit our website to get more infromation in www.website.com',
              style: TextStyle(
                  fontSize: 18
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
