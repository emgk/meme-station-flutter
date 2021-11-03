// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:memestation/pages/homepage.dart';
import 'package:memestation/pages/register.dart';
import 'package:memestation/services/api_service.dart';
import 'package:memestation/shared/formui.dart';
import 'package:memestation/shared/slideup.dart';

class Login extends StatefulWidget {
  @override
  _LoginStates createState() => _LoginStates();
}

class _LoginStates extends State<Login> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/default-monochrome.svg',
                height: 50,
                width: 10,
              ),
              Form(
                child: Theme(
                  data: ThemeData(
                    // brightness: Brightness.dark,
                    primarySwatch: Colors.grey,
                    inputDecorationTheme: InputDecorationTheme(
                      labelStyle: TextStyle(
                        // color: Colors.teal,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 15),
                        FormInput(
                          label: "Email",
                          child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20),
                              border: InputBorder.none,
                              hintText: 'Enter Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        SizedBox(height: 15),
                        FormInput(
                          label: "Password",
                          child: TextFormField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20),
                              border: InputBorder.none,
                              hintText: 'Enter Password',
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FormButton(label: "Login", onClick: doLogin),
                            SizedBox(height: 30),
                            SlideUp(
                              title: "Create new account",
                              description: "Please enter your details below",
                              child: Register(),
                              trigger: Text(
                                "Create new account",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> doLogin() async {
    if (passwordController.text.isNotEmpty && emailController.text.isNotEmpty) {
      // API request
      await APIService.login(
        emailController.text,
        passwordController.text,
      ).then((response) {
        if (response!.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logged in succesfully!'),
            ),
          );

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => HomePage()),
          );
        }
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid credentials!'),
          ),
        );
      });
    }
  }
}

Login login = Login();
