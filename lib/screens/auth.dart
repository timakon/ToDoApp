import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../domain/app_user.dart';

class AutorizationPage extends StatefulWidget {
  AutorizationPage({Key? key}) : super(key: key);

  @override
  State<AutorizationPage> createState() => _AutorizationPageState();
}

class _AutorizationPageState extends State<AutorizationPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String? _email;
  String? _password;
  bool showLogin = true;

  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    Widget _input(Icon icon, String hint, TextEditingController controller,
        bool obscure) {
      return Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(fontSize: 20, color: Colors.white),
          decoration: InputDecoration(
            hintStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white30),
            hintText: hint,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 3),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white54, width: 1),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: IconTheme(
                  data: const IconThemeData(color: Colors.white), child: icon),
            ),
          ),
        ),
      );
    }

    Widget _button(String label, void func()) {
      return TextButton(
          onPressed: () {
            func();
          },
          child: Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
          ),
          style: TextButton.styleFrom(
            backgroundColor: Color(0xFF009688),
            primary: Color(0xFF757575),
          ));
    }

    Widget _form(String label, void func()) {
      return Container(
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 10, top: 20),
            child: _input(Icon(Icons.email), "Email", _emailController, false),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child:
                _input(Icon(Icons.lock), "Password", _passwordController, true),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: _button(label, func),
            ),
          ),
        ]),
      );
    }

    void _loginButtonHandler() async {
      _email = _emailController.text;
      _password = _passwordController.text;

      if (_email!.isEmpty || _password!.isEmpty) {
        Fluttertoast.showToast(
          msg: "Invalid email or password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
          return;
      }

      AppUser? user = await _authService.singInWithEmailAndPassword(
          _email!.trim(), _password!.trim());
      if (user == null) {
        Fluttertoast.showToast(
            msg: "Can't sign in! Please check your email or password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        _emailController.clear();
        _passwordController.clear();
      }
    }

    void _registerButtonHandler() async {
      _email = _emailController.text;
      _password = _passwordController.text;

      if (_email!.isEmpty || _password!.isEmpty) {
        Fluttertoast.showToast(
            msg: "Invalid email or password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
            return;
      }

      AppUser? user = await _authService.registerWithEmailAndPassword(
          _email!.trim(), _password!.trim());
      if (user == null) {
        Fluttertoast.showToast(
            msg: "Can't register you! Please check your email or password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        _emailController.clear();
        _passwordController.clear();
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(bottom: 120)),
          (showLogin
              ? Column(
                  children: <Widget>[
                    _form('Login', _loginButtonHandler),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: GestureDetector(
                        child: Text(
                          "Not registered yet?",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        onTap: () {
                          setState(() {
                            showLogin = false;
                          });
                        },
                      ),
                    ),
                  ],
                )
              : Column(
                  children: <Widget>[
                    _form('Register', _registerButtonHandler),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: GestureDetector(
                        child: Text(
                          "Already registered?",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        onTap: () {
                          setState(() {
                            showLogin = true;
                          });
                        },
                      ),
                    ),
                  ],
                )),
        ],
      ),
    );
  }
}
