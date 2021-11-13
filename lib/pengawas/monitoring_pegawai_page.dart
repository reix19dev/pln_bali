import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pln_bali/pengawas/data_penugasan_pegawai_page.dart';
import 'package:pln_bali/utils/colors.dart';
import 'package:pln_bali/utils/font_styles.dart';

class MonitoringPegawaiPage extends StatefulWidget {
  final User user;
  const MonitoringPegawaiPage({Key? key, required this.user}) : super(key: key);

  @override
  _MonitoringPegawaiPageState createState() => _MonitoringPegawaiPageState();
}

class _MonitoringPegawaiPageState extends State<MonitoringPegawaiPage> {
  late Stream<QuerySnapshot> _usersStreamMine;

  @override
  void initState() {
    _usersStreamMine = FirebaseFirestore.instance
        .collection('users')
        .where('roleUser', isEqualTo: "Pegawai")
        .where('idKoor', isEqualTo: widget.user.uid)
        .snapshots();

    super.initState();
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
          "Monitoring Pegawai",
          style: fontStyle1.copyWith(
            fontWeight: FontWeight.bold,
            color: abuTua,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: StreamBuilder<QuerySnapshot>(
          stream: _usersStreamMine,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
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
                            FontAwesomeIcons.fileAlt,
                            color: abuTua,
                            size: 24.sp,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: DataPenugasanPegawaiPage(
                                  uidPegawai: document.id,
                                ),
                                type: PageTransitionType.rightToLeft,
                              ),
                            );
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
      ),
    );
  }
}
