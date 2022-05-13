import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/auth.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:provider/provider.dart';

import '../domain/app_user.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppUser? user = Provider.of<AppUser?>(context);

    final bool isLoggedIn = user != null;

    return isLoggedIn ? HomePage() : AutorizationPage();
  }
}
