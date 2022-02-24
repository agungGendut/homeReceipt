import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_color/random_color.dart';
import 'package:resepkita/bloc/NewReceipt_bloc/new_receipt_bloc.dart';
import 'package:resepkita/model/CategoryData.dart';
import 'package:resepkita/model/NewReceiptData.dart';
import 'package:resepkita/utils/LoadingPage.dart';

import 'ArticlePage/MainArticleScreen.dart';
import 'ProfileScreen/MainProfileScreen.dart';
import 'ReceiptPage/MainReceiptScreen.dart';
import 'ReceiptPage/component/DetailReceiptScreen.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.dataLogin}) : super(key: key);
  final String title;
  final User dataLogin;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User dataLogin;
  CategoryReceipt categoryReceipt;
  NewReceipt newReceipt;
  int _selectedIndex = 0;
  List<ColorHue> _hueType = <ColorHue>[
    ColorHue.green,
    ColorHue.red,
    ColorHue.pink,
    ColorHue.purple,
    ColorHue.blue,
    ColorHue.yellow,
    ColorHue.orange
  ];

  @override
  void initState() {
    dataLogin = widget.dataLogin;
    context.read<NewReceiptBloc>().add(GetNewReceiptData());
    super.initState();
  }

  Color setColor(int index){
    return RandomColor().randomColor(
        colorHue: ColorHue.multiple(colorHues: _hueType)); //if you want to change between 2 colors
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 0){
      Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) => MainReceiptScreen(dataLogin)
      ), (route) => false);
    }
    else if (_selectedIndex == 1){
      Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) => MainArticleScreen(dataLogin)
      ), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(),
        flexibleSpace: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 25, bottom: 5),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => MainProfileScreen(dataLogin)
                    ), (route) => false);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height / 5,
                    width: MediaQuery.of(context).size.width / 7,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(dataLogin.photoURL),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                ),
                Container(
                  child: Text(widget.title, style: GoogleFonts.lato(fontSize: 14, color: Colors.black87),),
                )
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<NewReceiptBloc, NewReceiptState>(
        builder: (context, state){
          if (state is ReceiptInitial){
            categoryReceipt = state.categoryReceipt;
            newReceipt = state.newReceipt;

            return CustomScrollView(
              primary: true,
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2.65,
                    width: MediaQuery.of(context).size.width / 1,
                    margin: EdgeInsets.all(10),
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                        ),
                        itemCount: categoryReceipt.results.length,
                        itemBuilder: (context, index){
                          return Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: setColor(index),
                              border: Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(15)
                            ),
                            child: Text(categoryReceipt.results[index].category,
                              style: GoogleFonts.lato(fontSize: 14, color: Colors.white),
                              textAlign: TextAlign.center,),
                          );
                        }),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2.5,
                    width: MediaQuery.of(context).size.width / 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text("Latest Update Receipt", style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 4,
                          width: MediaQuery.of(context).size.width / 1,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            children: List.generate(newReceipt.results.length, (index) {
                              return InkWell(
                                onTap: (){
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => DetailReceiptScreen(newReceipt.results[index].key, dataLogin)
                                      ), (route) => false);
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height / 2,
                                  width: MediaQuery.of(context).size.width / 1.5,
                                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                                  alignment: Alignment.bottomCenter,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      image: DecorationImage(
                                          image: NetworkImage(newReceipt.results[index].thumb),
                                          fit: BoxFit.cover
                                      ),
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height / 10,
                                    width: MediaQuery.of(context).size.width / 1,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.4),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(newReceipt.results[index].title, style: GoogleFonts.lato(fontSize: 12, color: Colors.black87),),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Text("Porsi : ", style: GoogleFonts.lato(fontSize: 12, color: Colors.black87),),
                                                    Text(newReceipt.results[index].portion, style: GoogleFonts.lato(fontSize: 12, color: Colors.black87),)
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Text("Kesulitan : ", style: GoogleFonts.lato(fontSize: 12, color: Colors.black87),),
                                                    Text(newReceipt.results[index].dificulty, style: GoogleFonts.lato(fontSize: 12, color: Colors.black87),)
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return LoadingPage();
        },
      ), // This
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.conciergeBell),
            label: 'Receipt',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.newspaper),
            label: 'Article',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),// trailing comma makes auto-formatting nicer for build methods.
    );
  }
}