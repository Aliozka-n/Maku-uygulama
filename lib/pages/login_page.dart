import 'package:flutter/material.dart';
import 'package:makuuygulama/auth_service.dart';
import 'package:makuuygulama/pages/guest_page.dart';
import 'package:makuuygulama/pages/register_page.dart';
import 'package:makuuygulama/pages/user_home_page_shema.dart';
import 'package:makuuygulama/pages/uygulama_promotion_page.dart';

class LoginPage extends StatelessWidget {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width / 25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(
                  elevation: 5,
                  child: Image.asset("images/indir.jpg"),
                ),
                buildSizedBox(context),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 10,
                  color: Colors.transparent,
                ),
                buildSizedBox(context),
                buildTextField(controller: _emailController, hinttext: "E-mail"),
                buildSizedBox(context),
                buildTextField(controller: _passwordController, hinttext: "Şifre", obscureText: true),
                buildSizedBox(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterPage()),
                          );
                        },
                        child: Text(
                          "Kayıt",
                          style: Theme.of(context).textTheme.headline4,
                        )),
                    ElevatedButton(
                      onPressed: () {
                        try {
                          _authService
                              .signIn(
                            _emailController.text,
                            _passwordController.text,
                          )
                              .then((value) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserHomePageShema(),
                              ),
                            );
                          }).onError((error, stackTrace) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Email yada şifre hatalı"),
                              ),
                            );
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Bir hata oluştu"),
                            ),
                          );
                        }
                      },
                      child: Text(
                        "Giriş",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    )
                  ],
                ),
                buildSizedBox(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GuestMain()));
                      },
                      child: Text(
                        "Misafir",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UygulamaTanitim()));
                      },
                      child: Text(
                        "Tanıtım",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextField buildTextField(
      {required TextEditingController controller, required String? hinttext, bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: "$hinttext",
      ),
    );
  }

  SizedBox buildSizedBox(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 50,
    );
  }
}
