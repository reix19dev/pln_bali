import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pln_bali/utils/colors.dart';
import 'package:pln_bali/utils/font_styles.dart';

class ListPegawaiPage extends StatefulWidget {
  final User user;
  const ListPegawaiPage({Key? key, required this.user}) : super(key: key);

  @override
  _ListPegawaiPageState createState() => _ListPegawaiPageState();
}

class _ListPegawaiPageState extends State<ListPegawaiPage> {
  late Stream<QuerySnapshot> _usersStreamMine;
  late Stream<QuerySnapshot> _usersStreamAll;

  @override
  void initState() {
    _usersStreamMine = FirebaseFirestore.instance
        .collection('users')
        .where('roleUser', isEqualTo: "Pegawai")
        .where('idKoor', isEqualTo: widget.user.uid)
        .snapshots();

    _usersStreamAll = FirebaseFirestore.instance
        .collection('users')
        .where("roleUser", isEqualTo: "Pegawai")
        .snapshots();

    super.initState();
  }

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

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "List Pegawai",
            style: fontStyle1.copyWith(
              fontWeight: FontWeight.bold,
              color: abuTua,
            ),
          ),
          bottom: TabBar(
            labelColor: abuMuda,
            indicatorColor: abuTua,
            tabs: [
              Tab(
                child: Center(
                  child: Text(
                    "Petugas Saya",
                    style: fontStyle2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Tab(
                child: Center(
                  child: Text(
                    "Sumua Petugas",
                    style: fontStyle2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _usersStreamMine,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: abuMuda,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['nama'],
                              style: fontStyle2.copyWith(
                                  color: abuTua, fontSize: 16.sp),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              data['nomorHP'],
                              style: fontStyle2.copyWith(color: abuMuda),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _usersStreamAll,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: abuMuda,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['nama'],
                                  style: fontStyle2.copyWith(
                                      color: abuTua, fontSize: 16.sp),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  data['nomorHP'],
                                  style: fontStyle2.copyWith(color: abuMuda),
                                ),
                              ],
                            ),
                            InkWell(
                              child: Icon(
                                FontAwesomeIcons.plusCircle,
                                color: abuTua,
                                size: 24.sp,
                              ),
                              onTap: () {
                                //data
                                if (data['idKoor'] == widget.user.uid) {
                                  tampilSnackBar(
                                      "${data['nama']} telah menjadi petugas anda.");
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        clipBehavior: Clip.none,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        content: Text(
                                          "Apakah anda yakin menambahkan ${data['nama']} sebagai petugas yang akan dimonitoring oleh anda?",
                                          style: fontStyle1.copyWith(
                                            color: abuMuda,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Tidak",
                                              style: fontStyle1.copyWith(
                                                  color: abuMuda),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              //tutup dialog
                                              Navigator.pop(context);

                                              //tambahkan jadi petugas saya
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(document.id)
                                                  .update({
                                                "idKoor": widget.user.uid,
                                              });
                                            },
                                            child: Container(
                                              width: 50.w,
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: abuMuda,
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Center(
                                                child: Text(
                                                  "Ya",
                                                  style: fontStyle1.copyWith(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
