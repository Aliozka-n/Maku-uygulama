import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:makuuygulama/firebase_service.dart';
import 'package:makuuygulama/pages/profile_edit_page.dart';

import '../consts/app_consts.dart';

class UserProfile extends StatefulWidget {
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  CollectionReference personRef = FireBaseService.personRef;

  @override
  Widget build(BuildContext context) {
    var userid = '';
    final FirebaseAuth _auth = FirebaseAuth.instance;
    PersonUid() {
      User? user = _auth.currentUser;
      final uid = user?.uid.toString();
      userid = uid.toString();
      //return uid;
    }

    PersonUid();
    CollectionReference personRef = FireBaseService.personRef;
    var userRef = personRef.doc('${userid}');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder(
                  stream: userRef.snapshots(),
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.hasError) {
                      return Text(AppConsts.somethingError);
                    } else if (asyncSnapshot.hasData) {
                      var userName = asyncSnapshot.data!.get("userName");
                      var mezunbolum = asyncSnapshot.data!.get("mezunbolum");
                      var il = asyncSnapshot.data!.get("il");
                      var hakkinda = asyncSnapshot.data!.get("hakkinda");
                      var email = asyncSnapshot.data!.get("email");
                      var calismadurum = asyncSnapshot.data!.get("calismadurum");

                      return buildColumn(userName, email, mezunbolum, il, calismadurum, hakkinda, context);
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column buildColumn(userName, email, section, county, workingStatus, aboutMe, BuildContext context) {
    return Column(
      children: [
        buildListTileWithSubtitle(title: AppConsts.userName, subtitle: userName, icon: Icons.account_circle),
        buildSizedBox(),
        buildListTileWithSubtitle(title: AppConsts.email, subtitle: email, icon: Icons.email),
        buildSizedBox(),
        buildListTile(title: AppConsts.section, value: section, icon: Icons.outlined_flag),
        buildSizedBox(),
        buildListTile(title: AppConsts.county, value: county, icon: Icons.location_city),
        buildSizedBox(),
        buildListTile(title: AppConsts.workingStatus, value: workingStatus, icon: Icons.ac_unit_outlined),
        buildSizedBox(),
        buildListTileWithSubtitle(title: AppConsts.aboutMe, subtitle: aboutMe, icon: Icons.book),
        buildSizedBox(),
        buildRow(context),
      ],
    );
  }

  Row buildRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserProfileSettingsWiget()),
            );
          },
          child: Icon(Icons.edit),
        )
      ],
    );
  }

  buildListTile({required String title, required String value, required var icon}) {
    return ListTile(
      shape: StadiumBorder(side: BorderSide()),
      title: Text("$title : $value"),
      leading: Icon(icon),
    );
  }

  ListTile buildListTileWithSubtitle({required String title, required String subtitle, required var icon}) {
    return ListTile(
      shape: StadiumBorder(side: BorderSide()),
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Icon(icon),
    );
  }

  SizedBox buildSizedBox() => SizedBox(height: 10);
}
