import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pln_bali/email_verification_page.dart';
import 'package:pln_bali/error_page.dart';
import 'package:pln_bali/loading_page.dart';
import 'package:pln_bali/login_register_page.dart';
import 'package:pln_bali/pegawai/home_pegawai_page.dart';
import 'package:pln_bali/pengawas/home_koordinator_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //initial user data.
            User user = snapshot.data!;

            if (!user.emailVerified) {
              return EmailVerificationPage();
            } else {
              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return ErrorPage();
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingPage();
                  }

                  if (snapshot.data!.get("roleUser") == "Pegawai") {
                    return HomePegawaiPage(
                      user: user,
                    );
                  } else {
                    return HomeKoordinatorPage(
                      user: user,
                    );
                  }
                },
              );
            }
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
