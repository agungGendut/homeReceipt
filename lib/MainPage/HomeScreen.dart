import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_color/random_color.dart';
import 'package:resepkita/bloc/NewReceipt_bloc/new_receipt_bloc.dart';
import 'package:resepkita/model/CategoryData.dart';
import 'package:resepkita/model/NewReceiptData.dart';
import 'package:resepkita/utils/LoadingPage.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../model/DetailReceiptData.dart';
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
  ScrollController sc = ScrollController();
  User dataLogin;
  CategoryReceipt categoryReceipt;
  List<ResultReceipt> newReceipt;
  DetailReceipt detailReceipt;
  int _selectedIndex = 0;
  int _currentItem;
  bool _visible = true;
  String imagePage;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NewReceiptBloc, NewReceiptState>(
        builder: (context, state){
          if (state is DetailInitial) detailReceipt = state.detailReceipt;
          if (state is ReceiptInitial) newReceipt = state.newReceipt.results;

          if (detailReceipt == null && newReceipt == null){
            return LoadingPage();
          } else {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imagePage == null
                            ? AssetImage("asset/Home.png")
                            : NetworkImage(imagePage),
                        fit: BoxFit.cover,
                      )
                  ),
                ),
                CustomScrollView(
                  primary: true,
                  slivers: [
                    SliverAppBar(
                      leading:  InkWell(
                        onTap: (){
                          // Navigator.of(context).pushAndRemoveUntil(
                          //     MaterialPageRoute(
                          //         builder: (context) => MainProfileScreen(dataLogin)
                          //     ), (route) => false);
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
                      title: Container(
                        child: Text(widget.title, style: GoogleFonts.lato(fontSize: 14, color: Colors.white),),
                      ),
                      centerTitle: true,
                      backgroundColor: Colors.transparent,
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 2.15,
                        width: MediaQuery.of(context).size.width / 1,
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(),
                        // child: CircleList(
                        //   origin: Offset(0, 0),
                        //   centerWidget: Container(
                        //     height: MediaQuery.of(context).size.height / 8,
                        //     width: MediaQuery.of(context).size.width / 4,
                        //     decoration: BoxDecoration(
                        //         color: Colors.blue,
                        //         border: Border.all(color: Colors.transparent),
                        //         borderRadius: BorderRadius.circular(20)
                        //     ),
                        //   ),
                        //   children: List.generate(categoryReceipt.results.length, (index) {
                        //     return Container(
                        //       alignment: Alignment.center,
                        //       decoration: BoxDecoration(
                        //           color: setColor(index),
                        //           border: Border.all(color: Colors.transparent),
                        //           borderRadius: BorderRadius.circular(15)
                        //       ),
                        //       child: Text(categoryReceipt.results[index].category,
                        //         style: GoogleFonts.lato(fontSize: 14, color: Colors.white),
                        //         textAlign: TextAlign.center,),
                        //     );
                        //   }),
                        // ),
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Latest Update Receipt", style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),),
                                  InkWell(
                                    onTap: (){
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) => MainReceiptScreen(dataLogin)
                                          ), (route) => false);
                                    },
                                    child: Text("See All", style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 3.2,
                              width: MediaQuery.of(context).size.width / 1,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                controller: sc,
                                itemCount: newReceipt.length,
                                itemBuilder: (context, index){
                                  return VisibilityDetector(
                                      key: Key(index.toString()),
                                      onVisibilityChanged: (VisibilityInfo info){
                                        setState(() {
                                          print(info.size);
                                          _currentItem = index;
                                          imagePage = newReceipt[index].thumb;
                                          print(_currentItem);
                                        });
                                        context.read<NewReceiptBloc>().add(GetDetailReceiptData(newReceipt[index].key));
                                      },
                                      child: InkWell(
                                        onTap: (){
                                          Navigator.of(context).pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (context) => DetailReceiptScreen(newReceipt[index].key, dataLogin)
                                              ), (route) => false);
                                        },
                                        child: Container(
                                          height: MediaQuery.of(context).size.height / 1,
                                          width: MediaQuery.of(context).size.width / 1.05,
                                          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                                          alignment: Alignment.bottomCenter,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              image: DecorationImage(
                                                  image: NetworkImage(newReceipt[index].thumb),
                                                  fit: BoxFit.cover
                                              ),
                                              borderRadius: BorderRadius.circular(20)
                                          ),
                                          child: Container(
                                            height: MediaQuery.of(context).size.height / 8,
                                            width: MediaQuery.of(context).size.width / 1,
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.4),
                                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(newReceipt[index].title, style: GoogleFonts.lato(fontSize: 14, color: Colors.black87),),
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            Text("Porsi : ", style: GoogleFonts.lato(fontSize: 12, color: Colors.black87),),
                                                            Text(newReceipt[index].portion, style: GoogleFonts.lato(fontSize: 12, color: Colors.black87),)
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            Text("Kesulitan : ", style: GoogleFonts.lato(fontSize: 12, color: Colors.black87),),
                                                            Text(newReceipt[index].dificulty, style: GoogleFonts.lato(fontSize: 12, color: Colors.black87),)
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Text("Waktu : ", style: GoogleFonts.lato(fontSize: 12, color: Colors.black87),),
                                                      Text(newReceipt[index].times, style: GoogleFonts.lato(fontSize: 12, color: Colors.black87),)
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Stack(
        fit: StackFit.loose,
        alignment: Alignment.centerRight,
        children: [
          Positioned(
            bottom: 420,
            right: 30,
            child: FloatingActionButton(
              heroTag: 'desc',
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return Container(
                        height: MediaQuery.of(context).size.height / 10,
                        width: MediaQuery.of(context).size.width / 10,
                        margin: EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 100),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Author: ${detailReceipt.results.author.user}"),
                                  Text("Publish: ${detailReceipt.results.author.datePublished}")
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text("Deskripsi", style: GoogleFonts.lato(fontSize: 18),),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Text(detailReceipt.results.desc, style: GoogleFonts.lato(fontSize: 13),),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                );
              },
              backgroundColor: Colors.grey.withOpacity(0.8),
              child: const Icon(
                Icons.details,
                size: 40,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              ),
            ),
          ),
          Positioned(
            bottom: 362,
            right: 30,
            child: FloatingActionButton(
              heroTag: 'menu',
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        margin: EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 100),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Container(
                              child: Text("Bahan Bahan", style: GoogleFonts.lato(fontSize: 18),),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width / 1.87,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context).size.height / 5,
                                            width: MediaQuery.of(context).size.width / 5,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(detailReceipt.results.needItem[0].thumbItem)
                                                )
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width / 3,
                                            child: Text(detailReceipt.results.needItem[0].itemName, maxLines: 2,),
                                          )
                                        ],
                                      )
                                  ),
                                  detailReceipt.results.needItem.length == 1 ? Container():
                                  Container(
                                      width: MediaQuery.of(context).size.width / 2,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context).size.height / 5,
                                            width: MediaQuery.of(context).size.width / 5,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(detailReceipt.results.needItem[1].thumbItem)
                                                )
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width / 4,
                                            child: Text(detailReceipt.results.needItem[1].itemName, maxLines: 2,),
                                          )
                                        ],
                                      )
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                );
              },
              backgroundColor: Colors.grey.withOpacity(0.8),
              child: const Icon(
                Icons.menu_book,
                size: 40,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
          ),
          Positioned(
            bottom: 304,
            right: 30,
            child: FloatingActionButton(
              heroTag: 'build',
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        margin: EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 100),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: Text("Cara Pengolahan", style: GoogleFonts.lato(fontSize: 18),),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 2,
                              width: MediaQuery.of(context).size.width / 1,
                              child: ListView(
                                children: List.generate(detailReceipt.results.step.length, (index) {
                                  return Container(
                                    margin: EdgeInsets.all(10),
                                    child: Text(detailReceipt.results.step[index]),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                );
              },
              backgroundColor: Colors.grey.withOpacity(0.8),
              child: const Icon(
                Icons.rice_bowl,
                size: 40,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}