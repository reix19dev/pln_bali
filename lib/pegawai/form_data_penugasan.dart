import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pln_bali/utils/colors.dart';
import 'package:pln_bali/utils/font_styles.dart';

class FormDataPenugasan extends StatefulWidget {
  const FormDataPenugasan({Key? key}) : super(key: key);

  @override
  _FormDataPenugasanState createState() => _FormDataPenugasanState();
}

TextEditingController _namaController = TextEditingController();
TextEditingController _nomorWAController = TextEditingController();
TextEditingController _idController = TextEditingController();
TextEditingController _alamatController = TextEditingController();
TextEditingController _nomorMeterController = TextEditingController();
TextEditingController _garduTiangController = TextEditingController();
TextEditingController _tarifDayaController = TextEditingController();
TextEditingController _kodeKedudukanController = TextEditingController();
TextEditingController _biayaRekeningController = TextEditingController();
TextEditingController _biayaKeterlambatanController = TextEditingController();

class _FormDataPenugasanState extends State<FormDataPenugasan> {
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              SizedBox(
                height: 16.h,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: TextField(
                  controller: _namaController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    labelText: "Nama",
                    labelStyle: fontStyle1.copyWith(color: abuMuda),
                    hintText: "Ramadhan Pratama",
                    hintStyle: fontStyle1.copyWith(
                        color: abuMuda.withOpacity(0.5), fontSize: 16),
                    prefixIcon: Icon(
                      FontAwesomeIcons.userAlt,
                      size: 16,
                      color: abuMuda,
                    ),
                  ),
                  keyboardType: TextInputType.name,
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
                  controller: _nomorWAController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    labelText: "Nomor WA",
                    labelStyle: fontStyle1.copyWith(color: abuMuda),
                    hintText: "08XXXXXXXXXX",
                    hintStyle: fontStyle1.copyWith(
                        color: abuMuda.withOpacity(0.5), fontSize: 16),
                    prefixIcon: Icon(
                      FontAwesomeIcons.lock,
                      size: 16,
                      color: abuMuda,
                    ),
                  ),
                  keyboardType: TextInputType.number,
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
                  controller: _idController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    labelText: "ID Pelanggan",
                    labelStyle: fontStyle1.copyWith(color: abuMuda),
                    hintText: "5511XXXXXXXX",
                    hintStyle: fontStyle1.copyWith(
                        color: abuMuda.withOpacity(0.5), fontSize: 16),
                    prefixIcon: Icon(
                      FontAwesomeIcons.lock,
                      size: 16,
                      color: abuMuda,
                    ),
                  ),
                  keyboardType: TextInputType.number,
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
                  controller: _alamatController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    labelText: "Alamat",
                    labelStyle: fontStyle1.copyWith(color: abuMuda),
                    hintText: "JL. Kampung Baru Gg. Syukur",
                    hintStyle: fontStyle1.copyWith(
                        color: abuMuda.withOpacity(0.5), fontSize: 16),
                    prefixIcon: Icon(
                      FontAwesomeIcons.lock,
                      size: 16,
                      color: abuMuda,
                    ),
                  ),
                  keyboardType: TextInputType.text,
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
                  controller: _nomorMeterController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    labelText: "Nomor Meter",
                    labelStyle: fontStyle1.copyWith(color: abuMuda),
                    hintText: "17XXXXXXXXXX",
                    hintStyle: fontStyle1.copyWith(
                        color: abuMuda.withOpacity(0.5), fontSize: 16),
                    prefixIcon: Icon(
                      FontAwesomeIcons.lock,
                      size: 16,
                      color: abuMuda,
                    ),
                  ),
                  keyboardType: TextInputType.number,
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
                  controller: _garduTiangController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    labelText: "Nama Gardu/Tiang",
                    labelStyle: fontStyle1.copyWith(color: abuMuda),
                    hintText: "GD5511/0022450",
                    hintStyle: fontStyle1.copyWith(
                        color: abuMuda.withOpacity(0.5), fontSize: 16),
                    prefixIcon: Icon(
                      FontAwesomeIcons.lock,
                      size: 16,
                      color: abuMuda,
                    ),
                  ),
                  keyboardType: TextInputType.number,
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
                  controller: _tarifDayaController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    labelText: "Tarip/Daya",
                    labelStyle: fontStyle1.copyWith(color: abuMuda),
                    hintText: "R3/10600 VA",
                    hintStyle: fontStyle1.copyWith(
                        color: abuMuda.withOpacity(0.5), fontSize: 16),
                    prefixIcon: Icon(
                      FontAwesomeIcons.lock,
                      size: 16,
                      color: abuMuda,
                    ),
                  ),
                  keyboardType: TextInputType.number,
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
                  controller: _kodeKedudukanController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    labelText: "Kode Kedudukan",
                    labelStyle: fontStyle1.copyWith(color: abuMuda),
                    hintText: "ABAABJE12300",
                    hintStyle: fontStyle1.copyWith(
                        color: abuMuda.withOpacity(0.5), fontSize: 16),
                    prefixIcon: Icon(
                      FontAwesomeIcons.lock,
                      size: 16,
                      color: abuMuda,
                    ),
                  ),
                  keyboardType: TextInputType.number,
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
                  controller: _biayaRekeningController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    labelText: "Biaya Rekening",
                    labelStyle: fontStyle1.copyWith(color: abuMuda),
                    hintText: "1000000",
                    hintStyle: fontStyle1.copyWith(
                        color: abuMuda.withOpacity(0.5), fontSize: 16),
                    prefixIcon: Icon(
                      FontAwesomeIcons.lock,
                      size: 16,
                      color: abuMuda,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              ElevatedButton(
                onPressed: () async {},
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Upload Data",
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
      ),
    );
  }
}
