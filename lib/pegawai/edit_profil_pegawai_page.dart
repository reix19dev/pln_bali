import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pln_bali/utils/colors.dart';
import 'package:pln_bali/utils/font_styles.dart';
import 'package:shimmer/shimmer.dart';

class EditProfilPegawaiPage extends StatefulWidget {
  final User user;
  const EditProfilPegawaiPage({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfilPegawaiPageState createState() => _EditProfilPegawaiPageState();
}

class _EditProfilPegawaiPageState extends State<EditProfilPegawaiPage> {
  //logic variable
  bool isLoading = false;

  //data variable
  String? nama = '';
  String? email = '';
  String? nomorHP = '';
  String? urlFotoProfil = '';
  String? koorID = '';
  bool isVerified = false;

  List<String> imgList = [];

  @override
  void initState() {
    getDataUser();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getDataUser() async {
    setState(() {
      isLoading = true;
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          nama = value.data()!['nama'] ?? '';
          email = value.data()!['email'] ?? '';
          nomorHP = value.data()!['nomorHP'] ?? '';
          urlFotoProfil = value.data()!['urlFotoProfil'] ?? '';
          isVerified = widget.user.emailVerified;

          print(nama);
          print(email);
        });
      }
    });

    setState(() {
      isLoading = false;
    });
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
          "Edit Data",
          style: fontStyle1.copyWith(
            fontWeight: FontWeight.bold,
            color: abuTua,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 64.h,
                width: 64.w,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: (isLoading)
                          ? Shimmer.fromColors(
                              baseColor: Colors.white,
                              highlightColor: Colors.grey.shade300,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4)),
                                height: 64.h,
                                width: 64.w,
                              ),
                            )
                          : (urlFotoProfil == "")
                              ? Container(
                                  height: 64.h,
                                  width: 64.w,
                                  decoration: BoxDecoration(color: abuMuda),
                                  child: Icon(
                                    FontAwesomeIcons.userAlt,
                                    color: Colors.white,
                                    size: 32.h,
                                  ),
                                )
                              : Image.network(
                                  urlFotoProfil!,
                                  fit: BoxFit.cover,
                                  height: 64.h,
                                  width: 64.w,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey.shade200,
                                      highlightColor: abuMuda,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        height: 64.h,
                                        width: 64.w,
                                      ),
                                    );
                                  },
                                ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        child: Icon(
                          FontAwesomeIcons.camera,
                          color: abuTua,
                        ),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 32.h,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  (isLoading)
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey.shade200,
                          highlightColor: abuMuda,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4)),
                            height: 16.h,
                            width: 160.w,
                          ),
                        )
                      : Row(
                          children: [
                            (isVerified)
                                ? Icon(
                                    FontAwesomeIcons.checkCircle,
                                    color: abuMuda,
                                    size: 20,
                                  )
                                : Icon(
                                    FontAwesomeIcons.exclamationCircle,
                                    color: Colors.redAccent,
                                    size: 20,
                                  ),
                            SizedBox(
                              width: 16.w,
                            ),
                            Expanded(
                              child: Text(
                                (isVerified)
                                    ? "Email anda telah diverifikasi."
                                    : "Silahkan verifikasi email anda terlebih dahulu.",
                                style: fontStyle2.copyWith(
                                    fontSize: 14.sp,
                                    color: (isVerified)
                                        ? abuMuda
                                        : Colors.redAccent),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 8.h,
                  ),
                  buildDataPegawai(
                    title: "Nama",
                    value: nama!,
                  ),
                  buildDataPegawai(
                    title: "Email",
                    value: email!,
                  ),
                  buildDataPegawai(
                    title: "Nomor HP",
                    value: nomorHP!,
                  ),
                  buildDataPegawai(
                    title: "ID Koordinator",
                    value: koorID!,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDataPegawai(
      {required String title, required String value, VoidCallback? onEdit}) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 3,
        shadowColor: abuMuda,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: fontStyle2,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  (isLoading)
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey.shade200,
                          highlightColor: abuMuda,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4)),
                            height: 16.h,
                            width: 160.w,
                          ),
                        )
                      : Text(
                          "${(value.isNotEmpty) ? value : "Belum tersedia"}",
                          style: fontStyle2.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                ],
              ),
              (onEdit == null)
                  ? Container()
                  : Material(
                      color: abuMuda,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: IconButton(
                        onPressed: onEdit,
                        icon: Icon(
                          FontAwesomeIcons.plusCircle,
                          color: Colors.white,
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
