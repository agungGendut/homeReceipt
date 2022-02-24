import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../HomeScreen.dart';

class MainArticleScreen extends StatefulWidget{
  final User dataLogin;
  MainArticleScreen(this.dataLogin);

  @override
  MainArticleScreenState createState() => MainArticleScreenState();
}

class MainArticleScreenState extends State<MainArticleScreen>{
  final TextEditingController searchController = TextEditingController();
  User dataLogin;

  @override
  void initState() {
    dataLogin = widget.dataLogin;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: (){
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => MyHomePage(title: dataLogin.displayName, dataLogin: dataLogin,)
                ), (route) => false);
          },
          child: Container(
            child: Icon(FontAwesomeIcons.arrowAltCircleLeft, color: Colors.amber[800],),
          ),
        ),
        title: Container(
          height: MediaQuery.of(context).size.height / 25,
          width: MediaQuery.of(context).size.width / 1.4,
          child: TextField(
            decoration: InputDecoration(
              labelText: "Search",
              labelStyle: TextStyle(fontSize: 12),
              border: OutlineInputBorder(
                borderRadius: new BorderRadius.circular(15),
                borderSide: new BorderSide(),
              ),
            ),
            keyboardType: TextInputType.multiline,
            autocorrect: false,
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchController.text = value;
              });
            },
          ),
        ),
        flexibleSpace: Container(
          decoration:
          BoxDecoration(
            image: DecorationImage(
              image: AssetImage("asset/Home.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}