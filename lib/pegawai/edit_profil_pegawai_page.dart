import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pln_bali/utils/colors.dart';
import 'package:pln_bali/utils/font_styles.dart';
import 'package:shimmer/shimmer.dart';

class EditProfilPegawaiPage extends StatefulWidget {
  final String uid;
  const EditProfilPegawaiPage({Key? key, required this.uid}) : super(key: key);

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
  bool isVerified = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        orientation: Orientation.portrait);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            width: 3,
            color: abuMuda,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            (!isVerified)
                ? Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.exclamationCircle,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      Expanded(
                        child: Text(
                          "Silahkan verifikasi email anda melalui edit profil.",
                          style: fontStyle2.copyWith(
                              fontSize: 14.sp, color: Colors.redAccent),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  )
                : Container(),
            SizedBox(
              height: 8.h,
            ),
            buildDataPegawai("Nomor HP", "TEST"),
          ],
        ),
      ),
    );
  }

  Widget buildDataPegawai(String title, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
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
                    value,
                    style: fontStyle2,
                  )
          ],
        ),
      ),
    );
  }
}
