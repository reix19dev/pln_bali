import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pln_bali/utils/colors.dart';
import 'package:pln_bali/utils/convert_waktu.dart';
import 'package:pln_bali/utils/font_styles.dart';
import 'package:shimmer/shimmer.dart';

class RiwayatPenugasanPage extends StatefulWidget {
  final User user;
  const RiwayatPenugasanPage({Key? key, required this.user}) : super(key: key);

  @override
  _RiwayatPenugasanPageState createState() => _RiwayatPenugasanPageState();
}

class _RiwayatPenugasanPageState extends State<RiwayatPenugasanPage> {
  bool isLoading = false;

  String tanggal = "Silahkan pilih tanggal";
  String nama = "";
  String nomorWA = "";
  String id = "";
  String alamat = "";
  String nomorMeter = "";
  String garduTiang = "";
  String taripDaya = "";
  String kodeKedudukan = "";
  int biayaRekening = 0;
  int biayaKeterlambatan = 0;
  String urlFotoLokasi1 = '';
  String urlFotoLokasi2 = '';
  String urlFotoLokasi3 = '';

  static DateTime today = DateTime.now();
  String tglPresensi = "${today.day}-${today.month}-${today.year}";
  int? intHari = -1;
  int? intJam = -1;

  @override
  void initState() {
    tanggal =
        '${convertHari(today.weekday)}, ${today.day} ${convertBulan(today.month)} ${today.year}';

    getDataPresensi(tglPresensi);

    super.initState();
  }

  Future<void> getDataPresensi(String tglPresensi) async {
    setState(() {
      isLoading = true;
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection("list_presensi")
        .doc("$tglPresensi")
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          nama = value.data()!['nama'] ?? '';
          nomorWA = value.data()!['nomorWa'] ?? '';
          id = value.data()!['id'] ?? '';
          alamat = value.data()!['alamat'] ?? '';
          nomorMeter = value.data()!['nomorMeter'] ?? '';
          garduTiang = value.data()!['garduTiang'] ?? '';
          taripDaya = value.data()!['taripDaya'] ?? '';
          kodeKedudukan = value.data()!['kodeKedudukan'] ?? '';
          biayaRekening = value.data()!['biayaRekening'] ?? 0;
          biayaKeterlambatan = value.data()!['biayaKeterlambatan'] ?? 0;
          urlFotoLokasi1 = value.data()!['urlFotoLokasi1'] ?? '';
          urlFotoLokasi2 = value.data()!['urlFotoLokasi2'] ?? '';
          urlFotoLokasi3 = value.data()!['urlFotoLokasi3'] ?? '';
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
          "Riwayat Penugasan",
          style: fontStyle1.copyWith(
            fontWeight: FontWeight.bold,
            color: abuTua,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: abuMuda, width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                padding: EdgeInsets.all(8),
                child: InkWell(
                  child: Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tanggal : ',
                            style: fontStyle1.copyWith(
                              color: abuTua,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                            tanggal,
                            style: fontStyle1.copyWith(
                              color: abuTua,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  onTap: () async {
                    DateTime? newDateTime = await showRoundedDatePicker(
                      context: context,
                      theme: ThemeData(
                        primarySwatch: Colors.blue,
                        primaryColor: Colors.blue[400],
                        accentColor: Colors.blue,
                        dialogBackgroundColor: Colors.blue.shade100,
                        textTheme: TextTheme(
                          bodyText1: TextStyle(color: Colors.blue),
                          caption: TextStyle(color: Colors.blue.shade800),
                        ),
                        disabledColor: Colors.blue,
                        accentTextTheme: TextTheme(
                          bodyText2: TextStyle(color: Colors.white),
                        ),
                      ),
                    );

                    String hari = convertHari(newDateTime!.weekday);
                    String bulan = convertBulan(newDateTime.month);
                    setState(() {
                      intHari = newDateTime.weekday;
                      tanggal =
                          '$hari, ${newDateTime.day} $bulan ${newDateTime.year}';
                      tglPresensi =
                          "${newDateTime.day}-${newDateTime.month}-${newDateTime.year}";
                    });

                    getDataPresensi(tglPresensi);
                  },
                ),
              ),
              Text(
                "Data Pelanggan",
                style: fontStyle1.copyWith(
                  color: abuTua,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: abuMuda, width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Column(
                  children: [
                    buildDataPelanggan(title: "Nama", value: nama),
                    buildDataPelanggan(title: "Nomor WA", value: nomorWA),
                    buildDataPelanggan(title: "ID Pelanggan", value: id),
                    buildDataPelanggan(title: "Alamat", value: alamat),
                    buildDataPelanggan(title: "Nomor Meter", value: nomorMeter),
                    buildDataPelanggan(title: "Gardu/Tiang", value: garduTiang),
                    buildDataPelanggan(title: "Tarip/Daya", value: taripDaya),
                    buildDataPelanggan(
                        title: "Kode Kedudukan", value: kodeKedudukan),
                    buildDataPelanggan(
                      title: "Biaya Rekening",
                      value: NumberFormat.currency(locale: "id", symbol: "Rp ")
                          .format(biayaRekening),
                    ),
                    buildDataPelanggan(
                      title: "Biaya Keterlambatan",
                      value: NumberFormat.currency(locale: "id", symbol: "Rp ")
                          .format(biayaKeterlambatan),
                    ),
                    buildDataPelanggan(
                      title: "Jumlah Tunggakan",
                      value: NumberFormat.currency(locale: "id", symbol: "Rp ")
                          .format(biayaRekening + biayaKeterlambatan),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Text(
                "Data Pelanggan",
                style: fontStyle1.copyWith(
                  color: abuTua,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: abuMuda, width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Column(
                  children: [
                    buildDataImagePasien("foto_lokasi_1"),
                    buildDataImagePasien("foto_lokasi_2"),
                    buildDataImagePasien("foto_lokasi_3"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDataPelanggan({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 1,
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
                          "${(value.isNotEmpty) ? value : "---"}",
                          style: fontStyle2.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDataImagePasien(String idFoto) {
    String? urlImage;
    if (idFoto == "foto_lokasi_1") {
      urlImage = urlFotoLokasi1;
      print(urlImage);
    } else if (idFoto == "foto_lokasi_2") {
      urlImage = urlFotoLokasi2;
      print(urlImage);
    } else if (idFoto == "foto_lokasi_3") {
      urlImage = urlFotoLokasi3;
      print(urlImage);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$idFoto',
            style: fontStyle2,
          ),
          SizedBox(
            height: 8,
          ),
          Stack(
            children: [
              Container(
                height: 160,
                width: double.infinity,
                child: (isLoading || urlImage!.isEmpty)
                    ? Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: 1.sw,
                          height: 130.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: abuTua,
                              width: 2,
                            ),
                          ),
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: Icon(
                              FontAwesomeIcons.image,
                              size: 100,
                              color: abuMuda,
                            ),
                          ),
                        ),
                      )
                    : Align(
                        alignment: Alignment.topLeft,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image(
                              image: NetworkImage(
                                urlImage,
                              ),
                              fit: BoxFit.contain,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Shimmer.fromColors(
                                  baseColor: Colors.white,
                                  highlightColor: Colors.grey.shade300,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4)),
                                    height: 160,
                                    width: double.infinity,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
