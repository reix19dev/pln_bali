import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:pln_bali/pengawas/data_penugasan_pegawai_page.dart';
import 'package:pln_bali/utils/colors.dart';
import 'package:pln_bali/utils/font_styles.dart';

class DataStatistikPage extends StatefulWidget {
  final String namaPegawai;
  final String uidPegawai;

  const DataStatistikPage(
      {Key? key, required this.uidPegawai, required this.namaPegawai})
      : super(key: key);

  @override
  _DataStatistikPageState createState() => _DataStatistikPageState();
}

class _DataStatistikPageState extends State<DataStatistikPage> {
  Map<String, double> dataMap = {
    "Selesai": 0,
    "Belum Selesai": 10,
  };

  @override
  void initState() {
    getDataStatistik();
    super.initState();
  }

  Future<void> getDataStatistik() async {
    DateTime now = DateTime.now();
    int totalSelesai = 0;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uidPegawai)
        .collection("list_presensi")
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        int tempValue = 0;
        value.docs.forEach((element) {
          if (element.get("bulanKerja") == now.month) {
            tempValue++;
          }
        });

        setState(() {
          totalSelesai = tempValue;
        });
      }
    });

    setState(() {
      dataMap["Selesai"] = totalSelesai.toDouble();
      dataMap["Belum Selesai"] = (10 - totalSelesai).toDouble();
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
          "Data Statistik",
          style: fontStyle1.copyWith(
            fontWeight: FontWeight.bold,
            color: abuTua,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: abuTua,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Berikut ini adalah persentase penugasan ${widget.namaPegawai} pada bulan ini.",
                        style: fontStyle1.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  PieChart(
                    dataMap: dataMap,
                    animationDuration: Duration(milliseconds: 800),
                   
                    chartRadius: 150.h,
                    colorList: [Colors.greenAccent, Colors.blueAccent],
                    initialAngleInDegree: 0,
                    chartType: ChartType.disc,
                    legendOptions: LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.bottom,
                      showLegends: true,
                      legendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    chartValuesOptions: ChartValuesOptions(
                      showChartValueBackground: true,
                      showChartValues: true,
                      showChartValuesInPercentage: true,
                      showChartValuesOutside: false,
                      decimalPlaces: 0,
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                              context,
                              PageTransition(
                                child: DataPenugasanPegawaiPage(
                                  uidPegawai: widget.uidPegawai,
                                ),
                                type: PageTransitionType.rightToLeft,
                              ),
                            );
                    },
                    child: Container(
                      width: 1.sw,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Lihat Riwayat Penugasan",
                            style: fontStyle1.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.h,
                            ),
                          ),
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: abuMuda,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                      )
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
