import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:makuuygulama/consts/app_consts.dart';
import 'package:makuuygulama/firebase_service.dart';
import 'package:makuuygulama/validation/userRegisterValidation.dart';

class UserProfileSettingsWiget extends StatefulWidget {
  @override
  State<UserProfileSettingsWiget> createState() => _UserProfileSettingsWigetState();
}

class _UserProfileSettingsWigetState extends State<UserProfileSettingsWiget> {
  final TextEditingController _nameController = TextEditingController();
  var textController = TextEditingController();

  UserRegiserValidations userValidate = UserRegiserValidations();
  String? secilenil = "Adana";
  String? secilenBolum = "Bilişim";
  String? secilenDurumu = "Çalışıyor";
  var bolumler = AppConsts.bolumler;
  var durumlar = AppConsts.durumlar;
  var iller = AppConsts.iller;
  var name = '';
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    personUid() {
      User? user = _auth.currentUser;
      final uid = user?.uid.toString();
      name = uid.toString();
      //return uid;
    }

    personUid();
    CollectionReference personRef = FireBaseService.personRef;
    var userRef = personRef.doc(name);
    return Container(
      child: Scaffold(
        //backgroundColor: Colors.transparent,
        backgroundColor: Colors.blue,

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          /// ad
                          buildTextField("Ad Soyad", _nameController,
                              errorText: userValidate.validateName(_nameController.value.text)),
                          buildSizedBox(),

                          /// il seçimi
                          buildDecoratedBox(secili: secilenil, liste: iller, stateA: "il"),
                          buildSizedBox(),

                          /// bölüm  adı listeden seçecek
                          buildDecoratedBox(secili: secilenBolum, liste: bolumler, stateA: "bolum"),
                          buildSizedBox(),

                          /// durum adı listeden seçecek
                          buildDecoratedBox(secili: secilenDurumu, liste: durumlar, stateA: "durum"),
                          buildSizedBox(),
                          TextField(
                            controller: textController,
                            maxLines: null,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              hintText: "Çalıştığınız işi özelteyiniz",
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          buildSizedBox(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            onPressed: () {
                              try {
                                if (_nameController.text.length > 5) {
                                  dynamic veri = {
                                    "userName": _nameController.text,
                                    "il": secilenil,
                                    "mezunbolum": secilenBolum,
                                    "calismadurum": secilenDurumu,
                                    "hakkinda": textController.text,
                                  };
                                  userRef.update(veri);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text("Kaydedildi"),
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Tekrar deneyin"),
                                    ),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Bir hata oluştu"),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              "Kaydet",
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DecoratedBox buildDecoratedBox({required List<String> liste, required String? secili, required String stateA}) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: Colors.red, //background color of dropdown button
          border: Border.all(color: Colors.black38, width: 3), //border of dropdown button
          borderRadius: BorderRadius.circular(10), //border raiuds of dropdown button
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
              if (stateA == "il") {
                secilenil = newValue;
              } else if (stateA == "bolum") {
                secilenBolum = newValue;
              } else if (stateA == "durum") {
                secilenDurumu = newValue;
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

  SizedBox buildSizedBox({double deger = 15}) {
    return SizedBox(
      height: deger,
    );
  }

  TextField buildTextField(String hintText, TextEditingController controller,
      {bool obscure = false, String? errorText}) {
    return TextField(
      style: TextStyle(color: Colors.white),
      obscureText: obscure,
      decoration: InputDecoration(
          errorText: errorText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
      controller: controller,
      onChanged: (text) => setState(() => controller.value.text),
    );
  }
}
