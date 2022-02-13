import 'package:flutter/material.dart';
import 'package:resepkita/MainPage/LoginScreen/component/GoogleButton.dart';

class MainLoginScreen extends StatefulWidget{

  @override
  MainLoginScreenState createState() => MainLoginScreenState();
}

class MainLoginScreenState extends State<MainLoginScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).size.height / 1.7,
              width: MediaQuery.of(context).size.width / 1,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("asset/Home.png"),
                  fit: BoxFit.cover
                )
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).size.height / 20,
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: GoogleLoginButton(),
            ),
          )
        ],
      ),
    );
  }
}