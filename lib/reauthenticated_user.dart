import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pln_bali/utils/colors.dart';
import 'package:pln_bali/utils/font_styles.dart';

class ReauthenticatedUser extends StatefulWidget {
  const ReauthenticatedUser({Key? key}) : super(key: key);

  @override
  _ReauthenticatedUserState createState() => _ReauthenticatedUserState();
}

TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

class _ReauthenticatedUserState extends State<ReauthenticatedUser> {
  bool isVisiblePass = false;
  bool isLoading = false;

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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: abuTua),
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.exclamationCircle,
                      color: abuTua,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        "Autentikasi ulang dibutuhkan ketika mengganti email pengguna upaya menjaga keamanan data.",
                        style: fontStyle2.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
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
                  hintText: "andibudi@gmail.com",
                  hintStyle: fontStyle1.copyWith(color: abuMuda, fontSize: 16),
                  prefixIcon: Icon(
                    FontAwesomeIcons.userAlt,
                    size: 16,
                    color: abuMuda,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: abuMuda),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: abuMuda),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  labelText: "Password",
                  labelStyle: fontStyle1.copyWith(color: abuMuda),
                  prefixIcon: Icon(
                    FontAwesomeIcons.lock,
                    size: 16,
                    color: abuMuda,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      (isVisiblePass)
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                    ),
                    onPressed: () {
                      setState(() {
                        isVisiblePass = !isVisiblePass;
                      });
                    },
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: !isVisiblePass,
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text.trim();
                String password = _passwordController.text.trim();

                if (email.isEmpty) {
                  tampilSnackBar('Nomor HP masih kosong. Silahkan input.');
                } else if (password.isEmpty) {
                  tampilSnackBar('Password masih kosong. Silahkan input.');
                } else {
                  setState(() {
                    isLoading = true;
                  });

                  try {
                    AuthCredential userCredential =
                        EmailAuthProvider.credential(
                            email: "$email", password: "$password");

                    Navigator.pop(context, userCredential);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      tampilSnackBar("Akun tidak ditemukan. Silahkan daftar.");
                    } else if (e.code == 'wrong-password') {
                      tampilSnackBar("Password anda salah. Coba lagi.");
                    }
                  }

                  _emailController.clear();
                  _passwordController.clear();

                  setState(() {
                    isLoading = false;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Autentikasi",
                  style: fontStyle1.copyWith(fontSize: 20, letterSpacing: 2),
                ),
              ),
              style: ElevatedButton.styleFrom(
                  primary: abuTua,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
            ),
            SizedBox(
              height: 16.h,
            ),
          ],
        ),
      ),
    );
  }
}
