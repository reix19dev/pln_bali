import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pln_bali/utils/colors.dart';
import 'package:pln_bali/utils/font_styles.dart';

class DataPelangganPage extends StatefulWidget {
  const DataPelangganPage({Key? key}) : super(key: key);

  @override
  _DataPelangganPageState createState() => _DataPelangganPageState();
}

class _DataPelangganPageState extends State<DataPelangganPage> {
  TextEditingController _idController = TextEditingController();
  Completer<GoogleMapController> _mapController = Completer();
  Map<String, Marker> _markers = {};

  CameraPosition _plnBaliPossition = CameraPosition(
    target: LatLng(-8.5834959, 115.1791433),
    zoom: 15,
  );

  bool isCariLoading = false;
  bool isDataKosong = true;

  String idPelanggan = '-';
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
  double koordinatX = 0;
  double koordinatY = 0;

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
                        tampilSnackBar("Data pelanggan tidak ditemukan");
                      } else if (value.docs.first.exists) {
                        setState(() {
                          isDataKosong = false;
                        });

                        setState(() {
                          idPelanggan =
                              value.docs.first.data()['idPelanggan'] ?? '-';
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
                          koordinatX =
                              value.docs.first.data()['koordinatX'] ?? 0;
                          koordinatY =
                              value.docs.first.data()['koordinatY'] ?? 0;
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
              (isCariLoading)
                  ? Container(
                      child: Text("Mencari data..."),
                    )
                  : (!isDataKosong)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              child: Column(
                                children: [
                                  buildDataPelanggan(
                                      title: "Unitup", value: unitup),
                                  buildDataPelanggan(
                                      title: "Nama", value: nama),
                                  buildDataPelanggan(
                                      title: "Nomor Telp", value: nomorTelp),
                                  buildDataPelanggan(
                                      title: "Nomor WA", value: nomorWA),
                                  buildDataPelanggan(
                                      title: "Alamat", value: alamat),
                                  buildDataPelanggan(
                                      title: "Nomor Meter", value: nomorMeter),
                                  buildDataPelanggan(
                                      title: "Gardu/Tiang", value: garduTiang),
                                  buildDataPelanggan(
                                      title: "Tarip/Daya", value: taripDaya),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            Text(
                              "Lokasi Pelanggan",
                              style: fontStyle1.copyWith(
                                color: abuTua,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: abuMuda, width: 3),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Container(
                                  height: 300.h,
                                  color: Colors.white,
                                  child: GoogleMap(
                                    mapType: MapType.hybrid,
                                    initialCameraPosition: _plnBaliPossition,
                                    markers: _markers.values.toSet(),
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      _mapController.complete(controller);
                                      setState(() {
                                        _markers.clear();
                                        final marker = Marker(
                                          markerId: MarkerId(idPelanggan),
                                          position:
                                              LatLng(koordinatX, koordinatY),
                                          infoWindow: InfoWindow(
                                            title: "Rumah Pelanggan",
                                          ),
                                          onTap: () {},
                                        );
                                        _markers["rumah_pelanggan"] = marker;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                CameraPosition _cameraPossition =
                                    CameraPosition(
                                  bearing: 200,
                                  target: LatLng(koordinatX, koordinatY),
                                  zoom: 20,
                                );

                                final GoogleMapController controller =
                                    await _mapController.future;
                                controller.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                      _cameraPossition),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: abuTua
                              ),
                              child: Text("Detail Lokasi Pelanggan"),
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                          ],
                        )
                      : Container(),
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
                  Text(
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
}
