import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:resepkita/MainPage/LoginScreen/MainLoginscreen.dart';
import 'package:resepkita/bloc/Auth_bloc/auth_bloc.dart';
import 'package:resepkita/bloc/NewReceipt_bloc/new_receipt_bloc.dart';
import 'package:resepkita/utils/LoadingPage.dart';

import 'MainPage/HomeScreen.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //or set color with: Color(0xFF0000FF)
    ));
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(MyApp());
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
          BlocProvider<NewReceiptBloc>(create: (context) => NewReceiptBloc()),
        ],
        child: MaterialApp(
          title: 'Resep Kita',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          builder: EasyLoading.init(),
          home: InitPage(),
        )
    );
  }
}

class InitPage extends StatefulWidget{

  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  User dataLogin;

  @override
  void initState() {
    context.read<AuthBloc>().add(CheckedAuth(context: context, splash: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state){
        if (state is AuthInitial) {
          context.read<NewReceiptBloc>().add(GetCategoryData());
        }
      },
      builder: (context, state){
        if (state is AuthInitial) {
          print("masuk sini sesudah login");
          dataLogin = state.userLogin;

          return MyHomePage(
              title: dataLogin.displayName,
              dataLogin: dataLogin,);
        }

        if (state is UnAuthInitial) {
          print("masuk sini sebelum login");
          return MainLoginScreen();
        }

        //return SplashScreen();
        return LoadingPage();
      },
    );
  }
}
