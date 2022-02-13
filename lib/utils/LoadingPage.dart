import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class LoadingPage extends StatefulWidget {
  final bool isPage;
  LoadingPage({this.isPage = true});
  @override
  LoadingPageState createState() => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage>{

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 8,
                ),
                Container(
                  child: Image.asset('asset/Home.png', scale: 3,),
                ),
                Container(
                  child: Image.asset("asset/loading.gif", ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 8,
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, state) {
                      if (state.hasData) {
                        return Text(state.data.version.toString());
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        onWillPop: null
    );
  }
}