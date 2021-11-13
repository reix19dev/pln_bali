import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pln_bali/utils/colors.dart';
import 'package:pln_bali/utils/font_styles.dart';

class MonitoringPegawaiPage extends StatefulWidget {
  final User user;
  const MonitoringPegawaiPage({Key? key, required this.user}) : super(key: key);

  @override
  _MonitoringPegawaiPageState createState() => _MonitoringPegawaiPageState();
}

class _MonitoringPegawaiPageState extends State<MonitoringPegawaiPage> {
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
      ),
    );
  }
}
