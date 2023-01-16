import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:makuuygulama/consts/sValue.dart';
import 'package:makuuygulama/firebase_service.dart';
import 'package:makuuygulama/pages/user_detay_page.dart';

class GuestMain extends StatefulWidget {
  @override
  State<GuestMain> createState() => _GuestMainState();
}

class _GuestMainState extends State<GuestMain> {
  String? secilenil = Svalue.secilenil;
  String? secilenBolum = Svalue.secilenBolum;

  var iller = Svalue.illerWithTumiller;
  var bolumler = Svalue.bolumlerWithTumbolumler;

  @override
  Widget build(BuildContext context) {
    CollectionReference personRef = FireBaseService.personRef;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width / 25),
          child: StreamBuilder<QuerySnapshot>(
            stream: personRef.snapshots(),
            builder: (BuildContext context, asyncSnapshot) {
              if (asyncSnapshot.hasError) {
                return const Center(
                  child: Text("İnternet bağlantnızı kontrol ediniz"),
                );
              } else if (asyncSnapshot.hasData) {
                List<DocumentSnapshot> listem = asyncSnapshot.data!.docs;
                return Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ///
                          buildDecoratedBox(
                              liste: iller, secili: secilenil, index: 0),
                          buildDecoratedBox(
                              liste: bolumler, secili: secilenBolum, index: 2),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: ListView.builder(
                        itemCount: listem.length,
                        itemBuilder: (context, index) {
                          if (secilenil == "Tüm iller" &&
                              secilenBolum == "Tüm bölümler") {
                            return buildInkWell(listem, index, context);
                          }
                          if (secilenil == listem[index].get('il') &&
                              secilenBolum == "Tüm bölümler") {
                            return buildInkWell(listem, index, context);
                          } else if (secilenil == listem[index].get('il') &&
                              secilenBolum == listem[index].get('mezunbolum')) {
                            return buildInkWell(listem, index, context);
                          } else if (secilenil == "Tüm iller" &&
                              secilenBolum == listem[index].get('mezunbolum')) {
                            return buildInkWell(listem, index, context);
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  buildInkWell(
      List<DocumentSnapshot<Object?>> listem, int index, BuildContext context) {
    try {
      bool onay = listem[index].get('onay');
      if (onay) {
        String alan = listem[index].get('alan');
        if (alan == "") {
          alan = "Bilinmiyor";
        }
        return InkWell(
          child: Card(
            elevation: 5,
            child: ListTile(
              leading: Column(
                children: [
                  const Icon(Icons.account_box),
                  Text('${listem[index].get('mezunbolum')}'),
                  Text('${listem[index].get('calismadurum')}'),
                ],
              ),
              title: Text('${listem[index].get('userName')}'),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${listem[index].get("hakkinda")}",
                    maxLines: 2,
                    // ...
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text("Alanı: $alan")
                ],
              ),
              trailing: Column(
                children: [
                  const Icon(Icons.read_more),
                  const Spacer(),
                  Text('${listem[index].get('il')}'),
                ],
              ),
              isThreeLine: true,
            ),
          ),
          // todo tıklandığında detay sayfasına git
          onTap: () {
            String userId = listem[index].id;
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserDetayPage(
                        userId: userId,
                      )),
            );
          },
        );
      } else {
        return SizedBox();
      }
    } catch (e) {
      return SizedBox();
    }
  }

  DecoratedBox buildDecoratedBox(
      {required List<String> liste,
      required String? secili,
      required int? index}) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: Colors.blue, //background color of dropdown button
          border: Border.all(
              color: Colors.black38, width: 3), //border of dropdown button
          borderRadius:
              BorderRadius.circular(10), //border raiuds of dropdown button
          boxShadow: <BoxShadow>[
            //apply shadow on Dropdown button
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                blurRadius: 5) //blur radius of shadow
          ]),
      child: Padding(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: DropdownButton(
          dropdownColor: Colors.blue,
          style: TextStyle(color: Colors.white),
          value: secili,
          onChanged: (String? newValue) {
            setState(() {
              if (index == 0) {
                this.secilenil = newValue;
              } else if (index == 2) {
                this.secilenBolum = newValue;
              }
            });
          },
          items: liste.map((String value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
