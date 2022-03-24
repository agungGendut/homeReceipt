import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resepkita/MainPage/HomeScreen.dart';
import 'package:resepkita/bloc/NewReceipt_bloc/new_receipt_bloc.dart';
import 'package:resepkita/model/ListReceiptData.dart';
import 'package:resepkita/utils/LoadingPage.dart';

import 'component/DetailReceiptScreen.dart';

class MainReceiptScreen extends StatefulWidget{
  final User dataLogin;
  MainReceiptScreen(this.dataLogin);

  @override
  MainReceiptScreenState createState() => MainReceiptScreenState();
}

class MainReceiptScreenState extends State<MainReceiptScreen>{
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  int page = 1;
  User dataLogin;
  List<Results> listReceipt = new List();

  @override
  void initState() {
    dataLogin = widget.dataLogin;
    context.read<NewReceiptBloc>().add(GetListReceiptData(page));
    super.initState();
  }

  Future _loadData() async {
    await new Future.delayed(new Duration(seconds: 2));
    page++;
    context.read<NewReceiptBloc>().add(GetListReceiptData(page));

    print("load more");

    setState(() {
      isLoading = false;
    });
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
      body: BlocConsumer<NewReceiptBloc, NewReceiptState>(
        listener: (context, state){
          if (state is ReceiptUnitial){
            return LoadingPage();
          }
        },
        builder: (context, state){
          if (state is ReceiptInitial){
            listReceipt.addAll(state.listReceipt.results);

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1,
                    width: MediaQuery.of(context).size.width / 1,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (!isLoading && scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                          _loadData();
                          // start loading data
                          setState(() {
                            isLoading = true;
                          });
                        }

                        return null;
                      },
                      child: ListView.builder(
                          itemCount: listReceipt.length,
                          itemBuilder: (context, index){
                            return InkWell(
                              onTap: (){
                                Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => DetailReceiptScreen(listReceipt[index].key, dataLogin)
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
                                        image: NetworkImage(listReceipt[index].thumb),
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
                                      Text(listReceipt[index].title, style: GoogleFonts.lato(fontSize: 12, color: Colors.black87),),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Row(
                                                children: [
                                                  Text("Porsi : ", style: GoogleFonts.lato(fontSize: 12, color: Colors.black87),),
                                                  Text(listReceipt[index].portion, style: GoogleFonts.lato(fontSize: 12, color: Colors.black87),)
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  Text("Kesulitan : ", style: GoogleFonts.lato(fontSize: 12, color: Colors.black87),),
                                                  Text(listReceipt[index].dificulty, style: GoogleFonts.lato(fontSize: 12, color: Colors.black87),)
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
                          }
                      ),
                    ),
                  ),
                )
              ],
            );
          }

          return LoadingPage();
        },
      ),
    );
  }
}