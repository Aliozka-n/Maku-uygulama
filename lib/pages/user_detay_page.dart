import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:makuuygulama/firebase_service.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDetayPage extends StatelessWidget {
  ///
  final String userId;
  UserDetayPage({required this.userId});

  ///
  @override
  Widget build(BuildContext context) {
    CollectionReference personRef = FireBaseService.personRef;
    var userRef = personRef.doc(userId);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('GUBYO MEZUN'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userRef.snapshots(),
        builder: (context, asyncSnaphot) {
          if (asyncSnaphot.hasError) {
            return Center(
              child: Text("İnternet bağlantnızı kontrol ediniz"),
            );
          } else if (asyncSnaphot.hasData) {
            var userName = asyncSnaphot.data?.get("userName");
            var calismadurum = asyncSnaphot.data?.get("calismadurum");
            var hakkinda = asyncSnaphot.data?.get("hakkinda");
            var mezunbolum = asyncSnaphot.data?.get("mezunbolum");
            var email = asyncSnaphot.data?.get("email");
            var ilAdi = asyncSnaphot.data?.get("il");

            return Card(
              margin: EdgeInsets.all(20),
              color: Colors.blue,
              //shape: StadiumBorder(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildListTileWithSubtitle(userName, hakkinda),
                    buildSizedBox(),
                    buildListTileWithSubtitle("Mezun olduğu bölüm", mezunbolum,
                        icon: Icons.ac_unit),
                    buildSizedBox(),
                    buildListTileWithSubtitle("Çalışma durumu", calismadurum,
                        icon: Icons.ac_unit),
                    buildSizedBox(),
                    buildListTileWithSubtitle("İl", ilAdi, icon: Icons.ac_unit),
                    buildSizedBox(),
                    ListTile(
                      leading: Icon(
                        Icons.ac_unit,
                        color: Colors.white,
                      ),
                      title: Text("E-mail adresi"),
                      subtitle: Text("$email"),
                      trailing: ElevatedButton(
                        onPressed: () {
                          String? encodeQueryParameters(
                              Map<String, String> params) {
                            return params.entries
                                .map((MapEntry<String, String> e) =>
                                    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                .join('&');
                          }

                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: '$email',
                            query: encodeQueryParameters(<String, String>{
                              'subject': '',
                            }),
                          );
                          launchUrl(emailLaunchUri);
                        },
                        child: Text("Mesaj at"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  ListTile buildListTileWithSubtitle(String userName, String hakkinda,
      {var icon = Icons.account_box}) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(userName),
      subtitle: Text(
        hakkinda,
      ),
    );
  }

  SizedBox buildSizedBox() {
    return SizedBox(
      height: 10,
    );
  }
}
