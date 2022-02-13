import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainProfileScreen extends StatefulWidget{
  final User dataLogin;
  MainProfileScreen(this.dataLogin);

  @override
  MainProfileScreenState createState() => MainProfileScreenState();
}

class MainProfileScreenState extends State<MainProfileScreen>{
  User dataLogin;

  @override
  void initState() {
    dataLogin = widget.dataLogin;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}