import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resepkita/bloc/Auth_bloc/auth_bloc.dart';

class GoogleLoginButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      icon: Icon(FontAwesomeIcons.google, color: Colors.white),
      onPressed: () => context.read<AuthBloc>().add(AuthByGoogle(context)),
      label: Text("Login Google", style: GoogleFonts.lato(color: Colors.black, textStyle: TextStyle(fontSize: 14))),
      color: Colors.redAccent,
    );
  }
}