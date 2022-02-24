import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resepkita/bloc/NewReceipt_bloc/new_receipt_bloc.dart';
import 'package:resepkita/model/DetailReceiptData.dart';
import 'package:resepkita/utils/LoadingPage.dart';

import '../../HomeScreen.dart';
import '../MainReceiptScreen.dart';

class DetailReceiptScreen extends StatefulWidget{
  final String detailKey;
  final User dataLogin;
  DetailReceiptScreen(this.detailKey, this.dataLogin);

  @override
  DetailReceiptScreenState createState() => DetailReceiptScreenState();
}

class DetailReceiptScreenState extends State<DetailReceiptScreen>{
  DetailReceipt detailReceipt;

  @override
  void initState() {
    context.read<NewReceiptBloc>().add(GetDetailReceiptData(widget.detailKey));
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
                    builder: (context) => MainReceiptScreen(widget.dataLogin,)
                ), (route) => false);
          },
          child: Container(
            child: Icon(FontAwesomeIcons.arrowAltCircleLeft, color: Colors.amber[800],),
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
      body: BlocBuilder<NewReceiptBloc, NewReceiptState>(
          builder: (context, state){
            if (state is DetailInitial){
              detailReceipt = state.detailReceipt;

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width / 1,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: detailReceipt.results.thumb != null 
                                  ? NetworkImage(detailReceipt.results.thumb)
                                  : AssetImage("asset/Home.png"),
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                          Container(
                            child: Text(detailReceipt.results.desc, style: GoogleFonts.lato(fontSize: 13),),
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Penyajian: ${detailReceipt.results.servings}"),
                                Text("Waktu Pembuatan: ${detailReceipt.results.times}")
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Kesulitan: ${detailReceipt.results.dificulty}"),
                                //Text("Waktu Pembuatan: ${detailReceipt.results.times}")
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
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
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate(
                          List.generate(detailReceipt.results.ingredient.length, (index) {
                            return Container(
                              margin: EdgeInsets.all(10),
                              child: Text(detailReceipt.results.ingredient[index]),
                            );
                          })
                      )
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text("Cara Pengolahan", style: GoogleFonts.lato(fontSize: 18),),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate(
                          List.generate(detailReceipt.results.step.length, (index) {
                            return Container(
                              margin: EdgeInsets.all(10),
                              child: Text(detailReceipt.results.step[index]),
                            );
                          })
                      )
                  ),
                ],
              );
            }

            return LoadingPage();
          }
      ),
    );
  }
}