import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/app_user.dart';
import 'package:flutter_application_1/screens/landing.dart';
import 'package:flutter_application_1/services/auth.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ToDoApp());
} 

class ToDoApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      value: AuthService().currentUser,
      initialData: null,
      child: MaterialApp(
        title: "ToDoApp",
        theme: ThemeData(
            primaryColor: Color(0xFF607D8B),
  
        ),
        home: LandingPage()),
    );
  }
}