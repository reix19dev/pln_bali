import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pln_bali/utils/colors.dart';
import 'package:pln_bali/utils/font_styles.dart';

class DataPelangganPage extends StatefulWidget {
  const DataPelangganPage({Key? key}) : super(key: key);

  @override
  _DataPelangganPageState createState() => _DataPelangganPageState();
}

class _DataPelangganPageState extends State<DataPelangganPage> {
  TextEditingController _idController = TextEditingController();

  bool isCariLoading = false;
  bool isDataKosong = false;

  String unitup = '-';
  String nama = '-';
  String namaPNJ = '-';
  String nomorTelp = '-';
  String nomorWA = '-';
  String alamat = '-';
  String nomorMeter = '-';
  String garduTiang = '-';
  String taripDaya = '-';
  String kodeKedudukan = '-';

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
          "Data Pelanggan",
          style: fontStyle1.copyWith(
            fontWeight: FontWeight.bold,
            color: abuTua,
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      FontAwesomeIcons.idCard,
                      size: 16,
                      color: abuMuda,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () async {
                    String idPelanggan = _idController.text.trim();
                    setState(() {
                      isCariLoading = true;
                    });

                    await FirebaseFirestore.instance
                        .collection('pelanggan')
                        .where("idPelanggan", isEqualTo: idPelanggan)
                        .get()
                        .then((value) {
                      if (value.docs.length == 0) {
                        setState(() {
                          isDataKosong = true;
                        });
                      } else if (value.docs.first.exists) {
                        setState(() {
                          unitup = value.docs.first.data()['unitup'] ?? '-';
                          nama = value.docs.first.data()['nama'] ?? '-';
                          namaPNJ = value.docs.first.data()['namaPNJ'] ?? '-';
                          nomorTelp =
                              value.docs.first.data()['nomorTelp'] ?? '-';
                          nomorWA = value.docs.first.data()['nomorWA'] ?? '-';
                          alamat = '-';
                          nomorMeter =
                              value.docs.first.data()['nomorMeter'] ?? '-';
                          garduTiang =
                              value.docs.first.data()['namaGardu'] ?? '-';
                          taripDaya =
                              '${value.docs.first.data()['tarif'] ?? '-'}/${value.docs.first.data()['daya'] ?? '-'}';
                          kodeKedudukan =
                              value.docs.first.data()['kodeKedudukan'] ?? '-';
                        });
                      }
                    });

                    setState(() {
                      isCariLoading = false;
                    });
                  },
                  child: Text(
                    "Cari Data",
                    style: fontStyle1.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: abuTua,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
