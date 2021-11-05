import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pln_bali/utils/colors.dart';
import 'package:pln_bali/utils/font_styles.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
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
      body: Container(
        height: 1.sh,
        width: 1.sw,
        color: abuTua,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 200.h,
                    child: Image.asset("assets/images/email_verification.png"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Silahkan cek email anda untuk verifikasi user. Kemudian tekan tombol dibawah ini jika sudah verifikasi melalui email.",
                      style: fontStyle1.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      //Back to login page
                      await FirebaseAuth.instance.signOut();
                    },
                    child: Text(
                      "Sudah Verifikasi",
                      style: fontStyle1.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
