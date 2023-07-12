import 'package:flutter/material.dart';
import 'package:makuuygulama/auth_service.dart';
import 'package:makuuygulama/consts/app_consts.dart';
import 'package:makuuygulama/pages/login_page.dart';
import 'package:makuuygulama/validation/userRegisterValidation.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AuthService _authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController = TextEditingController();
  var hakkindatextController = TextEditingController();
  var alantextController = TextEditingController();

  UserRegiserValidations userValidate = UserRegiserValidations();
  String? secilenil = "Adana";
  String? secilenBolum = "Bilişim";
  String? calismaDurumu = "Çalışıyor";
  var bolumler = AppConsts.bolumler;
  var durumlar = AppConsts.durumlar;
  var iller = AppConsts.iller;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                /*padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.28),*/
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

                          /// e mail
                          buildTextField("email", _emailController,
                              errorText: userValidate.validateEmail(_emailController.value.text)),
                          buildSizedBox(),

                          /// pasword
                          buildTextField("Password", _passwordController,
                              errorText: userValidate.validatePasword(_passwordController.value.text), obscure: true),
                          buildSizedBox(),

                          /// pasword again
                          buildTextField("Password", _passwordAgainController,
                              errorText: userValidate.validatePaswordAgain(
                                  _passwordController.value.text, _passwordAgainController.value.text),
                              obscure: true),
                          buildSizedBox(),

                          /// il seçimi
                          buildDecoratedBox(listem: iller, value: secilenil, hangialan: "il"),
                          buildSizedBox(),

                          /// bölüm  adı listeden seçecek
                          buildDecoratedBox(listem: bolumler, value: secilenBolum, hangialan: "bolum"),
                          buildSizedBox(),

                          /// durum adı listeden seçecek
                          buildDecoratedBox(listem: durumlar, value: calismaDurumu, hangialan: "calisma"),
                          buildSizedBox(),

                          /// alan
                          buildTextFieldNolimit(controller: alantextController, hintText: "Çalıştığınız anal nedir?"),
                          buildSizedBox(),

                          /// hakkinda
                          buildTextFieldNolimit(
                              controller: hakkindatextController, hintText: "Çalıştığınız işi özetleyiniz"),
                          buildSizedBox(),
                          ElevatedButton(
                            onPressed: () {
                              String? password = userValidate.validatePaswordAgain(
                                  _passwordAgainController.value.text, _passwordController.value.text);
                              String? email = userValidate.validateEmail(_emailController.value.text);
                              String? name = userValidate.validateName(_nameController.value.text);
                              if (password == null && email == null && name == null) {
                                _authService
                                    .createPerson(
                                        name: _nameController.text,
                                        email: _emailController.text,
                                        password: _passwordAgainController.text,
                                        mezunbolum: secilenBolum.toString(),
                                        calismadurum: calismaDurumu.toString(),
                                        hakkinda: hakkindatextController.text,
                                        il: secilenil.toString(),
                                        alan: alantextController.text)
                                    .then((value) => Navigator.pushReplacement(
                                        context, MaterialPageRoute(builder: (context) => LoginPage())));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Bir Hata oluştu"),
                                ));
                              }
                            },
                            child: Text(
                              'Kayıt Ol',
                              style: TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w700),
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

  DecoratedBox buildDecoratedBox({required String? value, required List<String> listem, required String hangialan}) {
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
          value: value,
          onChanged: (String? newValue) {
            setState(() {
              if (hangialan == "calisma") {
                calismaDurumu = newValue;
              } else if (hangialan == "bolum") {
                secilenBolum = newValue;
              } else if (hangialan == "il") {
                secilenil = newValue;
              }
            });
          },
          items: listem.map((String value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  TextField buildTextFieldNolimit({required TextEditingController controller, required String hintText}) {
    return TextField(
      controller: controller,
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
        hintText: "$hintText",
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
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
