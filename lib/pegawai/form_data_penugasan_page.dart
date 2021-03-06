import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pln_bali/pegawai/form_foto_lokasi_page.dart';
import 'package:pln_bali/utils/colors.dart';
import 'package:pln_bali/utils/font_styles.dart';

class FormDataPenugasanPage extends StatefulWidget {
  final User user;
  const FormDataPenugasanPage({Key? key, required this.user}) : super(key: key);

  @override
  _FormDataPenugasanPageState createState() => _FormDataPenugasanPageState();
}

class _FormDataPenugasanPageState extends State<FormDataPenugasanPage> {
  TextEditingController _unitupController = TextEditingController();
  TextEditingController _namaController = TextEditingController();
  TextEditingController _namaPNJController = TextEditingController();
  TextEditingController _nomorTelpController = TextEditingController();
  TextEditingController _nomorWAController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _nomorMeterController = TextEditingController();
  TextEditingController _garduTiangController = TextEditingController();
  TextEditingController _taripDayaController = TextEditingController();
  TextEditingController _kodeKedudukanController = TextEditingController();
  TextEditingController _biayaRekeningController = TextEditingController();
  TextEditingController _biayaKeterlambatanController = TextEditingController();

  int jumlahTunggakan = 0;
  bool isCariLoading = false;

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
                      if (value.docs.first.exists) {
                        setState(() {
                          _unitupController.text =
                              value.docs.first.data()['unitup'] ?? '-';
                          _namaController.text =
                              value.docs.first.data()['nama'] ?? '-';
                          _namaPNJController.text =
                              value.docs.first.data()['namaPNJ'] ?? '-';
                          _nomorTelpController.text =
                              value.docs.first.data()['nomorTelp'] ?? '-';
                          _nomorWAController.text =
                              value.docs.first.data()['nomorWA'] ?? '-';
                          _alamatController.text = '-';
                          _nomorMeterController.text =
                              value.docs.first.data()['nomorMeter'] ?? '-';
                          _garduTiangController.text =
                              value.docs.first.data()['namaGardu'] ?? '-';
                          _taripDayaController.text =
                              '${value.docs.first.data()['tarif'] ?? '-'}/${value.docs.first.data()['daya'] ?? '-'}';
                          _kodeKedudukanController.text =
                              value.docs.first.data()['kodeKedudukan'] ?? '-';
                        });
                      }
                    });

                    setState(() {
                      isCariLoading = false;
                    });
                  },
                  child: Text(
                    "Periksa",
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
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: TextField(
                  controller: _unitupController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    labelText: "Unitup",
                    labelStyle: fontStyle1.copyWith(color: abuMuda),
                    hintText: "55110",
                    hintStyle: fontStyle1.copyWith(
                        color: abuMuda.withOpacity(0.5), fontSize: 16),
                    prefixIcon: Icon(
                      FontAwesomeIcons.moneyCheckAlt,
                      size: 16,
                      color: abuMuda,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                height: 8.h,
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
                  controller: _namaPNJController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    labelText: "Nama Penanggung Jawab",
                    labelStyle: fontStyle1.copyWith(color: abuMuda),
                    hintText: "Surya Putra",
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
                  controller: _nomorTelpController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    labelText: "Nomor Telepon",
                    labelStyle: fontStyle1.copyWith(color: abuMuda),
                    hintText: "0XXXXXXXXX",
                    hintStyle: fontStyle1.copyWith(
                        color: abuMuda.withOpacity(0.5), fontSize: 16),
                    prefixIcon: Icon(
                      FontAwesomeIcons.phone,
                      size: 16,
                      color: abuMuda,
                    ),
                  ),
                  keyboardType: TextInputType.phone,
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
                      FontAwesomeIcons.phone,
                      size: 16,
                      color: abuMuda,
                    ),
                  ),
                  keyboardType: TextInputType.phone,
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
                      FontAwesomeIcons.addressCard,
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
                      FontAwesomeIcons.tachometerAlt,
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
                      FontAwesomeIcons.chargingStation,
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
                  controller: _taripDayaController,
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
                      FontAwesomeIcons.bolt,
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
                      FontAwesomeIcons.mapPin,
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
                      FontAwesomeIcons.moneyBillAlt,
                      size: 16,
                      color: abuMuda,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    String biayaKeterlambatan =
                        _biayaKeterlambatanController.text.isNotEmpty
                            ? _biayaKeterlambatanController.text
                            : "0";

                    if (value.isNotEmpty) {
                      setState(() {
                        jumlahTunggakan =
                            int.parse(value) + int.parse(biayaKeterlambatan);
                      });
                    } else {
                      jumlahTunggakan = int.parse(biayaKeterlambatan);
                    }
                    print(jumlahTunggakan);
                  },
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
                  controller: _biayaKeterlambatanController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: abuMuda),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    labelText: "Biaya Keterlambatan",
                    labelStyle: fontStyle1.copyWith(color: abuMuda),
                    hintText: "100000",
                    hintStyle: fontStyle1.copyWith(
                        color: abuMuda.withOpacity(0.5), fontSize: 16),
                    prefixIcon: Icon(
                      FontAwesomeIcons.moneyCheckAlt,
                      size: 16,
                      color: abuMuda,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    String biayaRekening =
                        _biayaRekeningController.text.isNotEmpty
                            ? _biayaRekeningController.text
                            : "0";

                    if (value.isNotEmpty) {
                      setState(() {
                        jumlahTunggakan =
                            int.parse(value) + int.parse(biayaRekening);
                      });
                    } else {
                      jumlahTunggakan = int.parse(biayaRekening);
                    }
                    print(jumlahTunggakan);
                  },
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Jumlah Tunggakan : ",
                      style: fontStyle1.copyWith(
                        color: abuMuda,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      NumberFormat.currency(locale: "id", symbol: "Rp ")
                          .format(jumlahTunggakan),
                      style: fontStyle1.copyWith(
                        color: abuTua,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              ElevatedButton(
                onPressed: () async {
                  String unitup = _unitupController.text;
                  String nama = _namaController.text;
                  String nomorTelp = _nomorTelpController.text;
                  String nomorWA = _nomorWAController.text;
                  String id = _idController.text;
                  String alamat = _alamatController.text;
                  String nomorMeter = _nomorMeterController.text;
                  String garduTiang = _garduTiangController.text;
                  String taripDaya = _taripDayaController.text;
                  String kodeKedudukan = _kodeKedudukanController.text;
                  int biayaRekening = int.parse(
                      _biayaRekeningController.text.isNotEmpty
                          ? _biayaRekeningController.text
                          : "0");
                  int biayaKeterlambatan = int.parse(
                      _biayaKeterlambatanController.text.isNotEmpty
                          ? _biayaKeterlambatanController.text
                          : "0");

                  if (nomorWA.isEmpty) {
                    tampilSnackBar("Nomor WA wajib diisi");
                  } else {
                    Map<String, dynamic> dataPelanggan = {
                      "unitup": unitup,
                      "nama": nama,
                      "nomorTelp": nomorTelp,
                      "nomorWA": nomorWA,
                      "id": id,
                      "alamat": alamat,
                      "nomorMeter": nomorMeter,
                      "garduTiang": garduTiang,
                      "taripDaya": taripDaya,
                      "kodeKedudukan": kodeKedudukan,
                      "biayaRekening": biayaRekening,
                      "biayaKeterlambatan": biayaKeterlambatan,
                      "jumlahTunggakan": jumlahTunggakan,
                    };
                    Navigator.push(
                      context,
                      PageTransition(
                        child: FormFotoLokasiPage(
                          user: widget.user,
                          dataPelanggan: dataPelanggan,
                        ),
                        type: PageTransitionType.rightToLeft,
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Simpan dan Foto Lokasi",
                    style: fontStyle1.copyWith(
                      fontSize: 18,
                    ),
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
