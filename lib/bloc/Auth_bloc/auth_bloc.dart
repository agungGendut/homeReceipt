import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  User userLogin;
  AuthBloc() : super(LoadingInitial());

  @override
  Stream<AuthState> mapEventToState(
      AuthEvent event,
      ) async* {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (event is CheckedAuth) {
      if (event.splash) {
        await Future.delayed(Duration(seconds: 4));
      }
      bool isLogin = sharedPreferences.getBool('login_status') == null ? false: sharedPreferences.getBool('login_status');
      // String data = sharedPreferences.getString('login_data') == null ? "": sharedPreferences.getString('login_data');
      // print("data check auth $data");
      print("login check auth $isLogin");
      if (isLogin == true) {
        print("masuk klo masih login");
        if (_auth.currentUser != null){
          print("data check auth ${_auth.currentUser}");
          this.userLogin = _auth.currentUser;
          yield AuthInitial(this.userLogin.displayName, this.userLogin);
        }
      } else {
        print("masuk klo belum login");
        await sharedPreferences.setBool('login_status', false);
        yield UnAuthInitial();
      }
    }

    if (event is AuthByGoogle) {
      GoogleSignInAccount googleSignInAccount = _googleSignIn.currentUser;

      if (googleSignInAccount == null) {
        googleSignInAccount = await _googleSignIn.signIn();
      }

      GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      add(LoginCredential(event.context, credential: credential));
    }

    if (event is LoginCredential) {
      yield LoadingInitial();
      if (_auth.currentUser != null) _auth.signOut();
      UserCredential authResult = await _auth.signInWithCredential(event.credential);
      User user = authResult.user;
      print("User firebase1: ${authResult.user}");
      if (user.emailVerified == true){
        print("${user.emailVerified}");
        add(AuthSuccess(event.context, user));
      }
    }

    if (event is AuthSuccess) {
      await sharedPreferences.setBool('login_status', true);
      // await sharedPreferences.setString('login_data', json.encode(event.auth));
      print("User firebase2: ${event.auth}");
      this.userLogin = event.auth;
      yield AuthInitial(this.userLogin.displayName, this.userLogin);
      //Navigator.pushAndRemoveUntil(event.context, MaterialPageRoute(builder: (context) => MyApp()), (route) => true);
    }
  }
}
