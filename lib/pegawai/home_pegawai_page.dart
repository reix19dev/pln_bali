import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pln_bali/pegawai/data_pelanggan_page.dart';
import 'package:pln_bali/pegawai/edit_profil_pegawai_page.dart';
import 'package:pln_bali/pegawai/form_data_penugasan_page.dart';
import 'package:pln_bali/pegawai/riwayat_penugasan_page.dart';
import 'package:pln_bali/utils/colors.dart';
import 'package:pln_bali/utils/dataTest.dart';
import 'package:pln_bali/utils/font_styles.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePegawaiPage extends StatefulWidget {
  final User user;
  const HomePegawaiPage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePegawaiPageState createState() => _HomePegawaiPageState();
}

class _HomePegawaiPageState extends State<HomePegawaiPage> {
  //controller
  CarouselController _carouselController = CarouselController();

  //logic variable
  bool isLoading = false;
  bool isLoadingEvent = false;

  //data variable
  String nama = '';
  String email = '';
  String nomorHP = '';
  String urlFotoProfil = '';
  bool isVerified = false;

  List<String> imgList = [];

  @override
  void initState() {
    getDataUser();
    getBannerInfo();
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
          nomorHP = value.data()!['nomor_hp'] ?? '';
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

  Future<void> getBannerInfo() async {
    setState(() {
      isLoading = true;
    });

    await FirebaseFirestore.instance.collection('banners').get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          imgList.add(element.data()["imgLink"]);
        });
      });
    });

    setState(() {
      isLoading = false;
    });
  }

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

    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                clipBehavior: Clip.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                content: Text(
                  "Apakah anda yakin ingin keluar dari aplikasi ?",
                  style: fontStyle1.copyWith(
                    color: abuMuda,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: abuMuda,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        "Tidak",
                        style: fontStyle1.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: Text(
                      "Ya",
                      style: fontStyle1.copyWith(color: abuMuda),
                    ),
                  ),
                ],
              );
            });
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      clipBehavior: Clip.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      content: Text(
                        "Apakah anda yakin ingin keluar dari akun anda?",
                        style: fontStyle1.copyWith(
                          color: abuMuda,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: abuMuda,
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              "Tidak",
                              style: fontStyle1.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Ya",
                            style: fontStyle1.copyWith(color: abuMuda),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                FontAwesomeIcons.signOutAlt,
                color: abuTua,
              ),
            ),
            // IconButton(
            //   onPressed: () async {
            //     for (int i = 0; i < dataTest.length; i++) {
            //       Map<String, dynamic> dataUser = {
            //         "unitup": dataTest[i]["unitup"] ?? "-",
            //         "idPelanggan": dataTest[i]["idPelanggan"] ?? "-",
            //         "nama": dataTest[i]["nama"] ?? "-",
            //         "namaPNJ": dataTest[i]["namaPNJ"] ?? "-",
            //         "tarif": dataTest[i]["tarif"] ?? "-",
            //         "daya": dataTest[i]["daya"] ?? "-",
            //         "nomorTelp": dataTest[i]["nomorTelp"] ?? "-",
            //         "nomorWA": dataTest[i]["nomorWA"] ?? "-",
            //         "jenisLayanan": dataTest[i]["jenisLayanan"] ?? "-",
            //         "kodeKedudukan": dataTest[i]["kodeKedudukan"] ?? "-",
            //         "nomorMeter": dataTest[i]["nomorMeter"] ?? "-",
            //         "merkMeter": dataTest[i]["merkMeter"] ?? "-",
            //         "typeMeter": dataTest[i]["typeMeter"] ?? "-",
            //         "tahunBuatMeter": dataTest[i]["tahunBuatMeter"] ?? "-",
            //         "nomorGardu": dataTest[i]["nomorGardu"] ?? "-",
            //         "namaGardu": dataTest[i]["namaGardu"] ?? "-",
            //         "kapasitasTrafo": dataTest[i]["kapasitasTrafo"] ?? "-",
            //         "tegangan": dataTest[i]["tegangan"] ?? "-",
            //         "nomorMeterPrepaid":
            //             dataTest[i]["nomorMeterPrepaid"] ?? "-",
            //         "koordinatX": double.parse(
            //             (dataTest[i]["koordinatX"] ?? "0").toString()),
            //         "koordinatY": double.parse(
            //             (dataTest[i]["koordinatY"] ?? "0").toString()),
            //         "namaUP": dataTest[i]["namaUP"] ?? "-"
            //       };

            //       await FirebaseFirestore.instance
            //           .collection("pelanggan")
            //           .add(dataUser);
            //     }
            //   },
            //   icon: Icon(
            //     FontAwesomeIcons.book,
            //     color: abuTua,
            //   ),
            // )
          ],
          title: Row(
            children: [
              Text(
                "IDETECH",
                style: fontStyle1.copyWith(
                  fontWeight: FontWeight.bold,
                  color: abuTua,
                ),
              ),
              Container(
                height: 50,
                child: Image.asset("assets/images/logo_abu_tua.png"),
              ),
            ],
          ),
        ),
        body: Container(
          color: Colors.white,
          height: double.infinity,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildHeaderUI(),
                        SizedBox(
                          height: 8.h,
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: _buildFotoProfilUI(),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 0.21.sh,
                        ),
                        Text(
                          "Item Menu",
                          style: fontStyle2.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 20.sp),
                        ),
                        Divider(
                          color: abuMuda,
                        ),
                        SizedBox(
                          height: 120.h,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                menuItemWidget(
                                  namaMenu: "Checkin Penugasan",
                                  iconData: FontAwesomeIcons.userCheck,
                                  onPressed: () async {
                                    DateTime today = DateTime.now();
                                    String tglPresensi =
                                        "${today.day}-${today.month}-${today.year}";

                                    late bool isCheckIn;

                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(widget.user.uid)
                                        .collection("list_presensi")
                                        .doc("$tglPresensi")
                                        .get()
                                        .then((value) {
                                      if (value.exists) {
                                        isCheckIn = true;
                                      } else {
                                        isCheckIn = false;
                                      }
                                    });

                                    if (!isCheckIn) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            clipBehavior: Clip.none,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            content: Text(
                                              "Fitur ini merekam koordinat lokasi anda. Pastikan anda telah berada dilokasi pelanggan sebelum melakukan checkin. Apakah anda sudah dilokasi pelanggan?",
                                              style: fontStyle1.copyWith(
                                                color: abuMuda,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                      color: abuMuda,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Text(
                                                    "Tidak",
                                                    style: fontStyle1.copyWith(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  Map<String, dynamic>
                                                      dataPresensi = {
                                                    "isCheckIn": true,
                                                  };

                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("users")
                                                      .doc(widget.user.uid)
                                                      .collection(
                                                          "list_presensi")
                                                      .doc("$tglPresensi")
                                                      .set(dataPresensi);

                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                      color: abuMuda,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Text(
                                                    "OK",
                                                    style: fontStyle1.copyWith(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      tampilSnackBar(
                                          "Anda telah melakukan checkin penugasan");
                                    }
                                  },
                                ),
                                menuItemWidget(
                                  namaMenu: "Input Data Penugasan",
                                  iconData: FontAwesomeIcons.penAlt,
                                  onPressed: () async {
                                    DateTime today = DateTime.now();
                                    String tglPresensi =
                                        "${today.day}-${today.month}-${today.year}";

                                    late bool isCheckIn;

                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(widget.user.uid)
                                        .collection("list_presensi")
                                        .doc("$tglPresensi")
                                        .get()
                                        .then((value) {
                                      if (value.exists) {
                                        isCheckIn = true;
                                      } else {
                                        isCheckIn = false;
                                      }
                                    });

                                    if (!isCheckIn) {
                                      tampilSnackBar(
                                          "Anda belum melakukan checkin penugasan");
                                    } else {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                            child: FormDataPenugasanPage(
                                              user: widget.user,
                                            ),
                                            type:
                                                PageTransitionType.rightToLeft,
                                          ));
                                    }
                                  },
                                ),
                                menuItemWidget(
                                    namaMenu: "Riwayat Penugasan",
                                    iconData: FontAwesomeIcons.addressBook,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          child: RiwayatPenugasanPage(
                                            user: widget.user,
                                          ),
                                          type: PageTransitionType.rightToLeft,
                                        ),
                                      );
                                    }),
                                menuItemWidget(
                                    namaMenu: "Data Pelanggan",
                                    iconData: FontAwesomeIcons.addressBook,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                            child: DataPelangganPage(),
                                            type:
                                                PageTransitionType.rightToLeft,
                                          ));
                                    }),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18.h,
                        ),
                        Text(
                          "Info",
                          style: fontStyle2.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 20.sp),
                        ),
                        Divider(
                          color: abuMuda,
                        ),
                        CarouselSlider(
                          items: imgList.map(
                            (item) {
                              return (isLoading)
                                  ? Shimmer.fromColors(
                                      baseColor: Colors.white,
                                      highlightColor: Colors.grey.shade300,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        height: 200.h,
                                        width: double.infinity,
                                      ),
                                    )
                                  : InkWell(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        child: Container(
                                          width: double.infinity,
                                          child: CachedNetworkImage(
                                            fit: BoxFit.fill,
                                            imageUrl: '$item',
                                            placeholder: (context, url) =>
                                                Shimmer.fromColors(
                                              baseColor: Colors.white,
                                              highlightColor:
                                                  Colors.grey.shade300,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                height: 200.h,
                                                width: double.infinity,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                            fadeOutDuration:
                                                const Duration(seconds: 1),
                                            fadeInDuration:
                                                const Duration(seconds: 1),
                                          ),
                                        ),
                                      ),
                                      onTap: () async {
                                        if (!isLoading) {}
                                        String _url = "https://web.pln.co.id/";
                                        await canLaunch(_url)
                                            ? await launch(_url)
                                            : throw 'Could not launch $_url';
                                      },
                                    );
                            },
                          ).toList(),
                          options: CarouselOptions(
                            initialPage: 0,
                            autoPlay: true,
                            aspectRatio: 2 / 1,
                            viewportFraction: 1,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlayInterval: Duration(seconds: 5),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                          ),
                          carouselController: _carouselController,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget menuItemWidget(
      {required String namaMenu,
      required IconData iconData,
      VoidCallback? onPressed}) {
    return InkWell(
      child: Card(
        shadowColor: abuMuda,
        elevation: 3,
        borderOnForeground: false,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          width: 100,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: abuMuda, borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                iconData,
                color: Colors.white,
                size: 32.h,
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                "$namaMenu",
                style: fontStyle1.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
      onTap: onPressed,
    );
  }

  Widget _buildFotoProfilUI() {
    return ClipRRect(
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
                  urlFotoProfil,
                  fit: BoxFit.cover,
                  height: 64.h,
                  width: 64.w,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade200,
                      highlightColor: abuMuda,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4)),
                        height: 64.h,
                        width: 64.w,
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildHeaderUI() {
    return Container(
      margin: EdgeInsets.only(top: 32),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          width: 3,
          color: abuMuda,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (isLoading = false)
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
                        "$nama",
                        style: fontStyle2.copyWith(fontWeight: FontWeight.bold),
                      ),
                SizedBox(
                  height: 4.h,
                ),
                (isLoading = false)
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
                        "$email",
                        style: fontStyle2,
                      )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                (isLoading)
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey.shade200,
                        highlightColor: abuMuda,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4)),
                          height: 12.h,
                          width: 80.w,
                        ),
                      )
                    : (isVerified)
                        ? Row(
                            children: [
                              Text(
                                "Terverifikasi",
                                style: fontStyle1.copyWith(
                                  color: abuMuda,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              Icon(
                                FontAwesomeIcons.checkCircle,
                                size: 12,
                                color: abuMuda,
                              )
                            ],
                          )
                        : Row(
                            children: [
                              Text(
                                "Belum Terverifikasi",
                                style: fontStyle1.copyWith(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              Icon(
                                FontAwesomeIcons.exclamationCircle,
                                size: 12,
                                color: Colors.redAccent,
                              )
                            ],
                          ),
                SizedBox(
                  height: 8.h,
                ),
                ElevatedButton(
                  onPressed: () {
                    //Navigasi ke edit_profil_pegawai_page
                    Navigator.push(
                      context,
                      PageTransition(
                        child: EditProfilPegawaiPage(
                          user: widget.user,
                        ),
                        type: PageTransitionType.rightToLeft,
                      ),
                    );
                  },
                  child: Text("Edit Profil"),
                  style: ElevatedButton.styleFrom(
                    primary: abuMuda,
                    textStyle: fontStyle1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
