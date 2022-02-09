import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pln_bali/utils/colors.dart';
import 'package:pln_bali/utils/font_styles.dart';

class LupaPassword extends StatefulWidget {
  const LupaPassword({Key? key}) : super(key: key);

  @override
  _LupaPasswordState createState() => _LupaPasswordState();
}

final TextEditingController _emailController = TextEditingController();

class _LupaPasswordState extends State<LupaPassword> {
  //variable logic
  bool isLoading = false;

  // snackBar Widget
  tampilSnackBar(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: abuTua,
        content: Text(
          '$message',
          style: fontStyle1,
        ),
        duration: Duration(milliseconds: 2000),
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        orientation: Orientation.portrait);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Lupa Password",
          style: fontStyle1.copyWith(
            fontWeight: FontWeight.bold,
            color: abuTua,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          color: Colors.white,
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    labelText: "Email",
                    labelStyle: fontStyle1.copyWith(color: abuMuda),
                    prefixIcon: Icon(
                      FontAwesomeIcons.envelope,
                      size: 16,
                      color: abuMuda,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(
                height: 32.h,
              ),
              ElevatedButton(
                onPressed: () async {
                  String email = _emailController.text.trim();

                  if (email.isEmpty) {
                    tampilSnackBar('Email  masih kosong. Silahkan input.');
                  } else {
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: email);

                      tampilSnackBar(
                            "Link reset password terkirim. Silahkan periksa email anda.");

                      Navigator.pop(context);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'invalid-email') {
                        tampilSnackBar(
                            "Email tidak valid. Silahkan ketik email dengan benar.");
                      } else if (e.code == 'user-not-found') {
                        tampilSnackBar(
                            "Akun tidak ditemukan. Silahkan daftar.");
                      }

                      _emailController.clear();

                      setState(() {
                        isLoading = false;
                      });
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Reset Password",
                    style: fontStyle1.copyWith(fontSize: 20, letterSpacing: 2),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: abuTua,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
