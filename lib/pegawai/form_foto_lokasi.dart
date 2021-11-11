import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pln_bali/utils/colors.dart';
import 'package:pln_bali/utils/font_styles.dart';

class FormFotoLokasi extends StatefulWidget {
  final Map<String, dynamic> dataPelanggan;

  const FormFotoLokasi({Key? key, required this.dataPelanggan})
      : super(key: key);

  @override
  _FormFotoLokasiState createState() => _FormFotoLokasiState();
}

class _FormFotoLokasiState extends State<FormFotoLokasi> {

  @override
  void initState() {
    print(widget.dataPelanggan);
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
          "Form Penugasan",
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
