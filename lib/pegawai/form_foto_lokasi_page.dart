import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pln_bali/pegawai/home_pegawai_page.dart';
import 'package:pln_bali/pegawai/take_picture_page.dart';
import 'package:pln_bali/utils/colors.dart';
import 'package:pln_bali/utils/font_styles.dart';
import 'package:shimmer/shimmer.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FormFotoLokasiPage extends StatefulWidget {
  final User user;
  final Map<String, dynamic> dataPelanggan;

  const FormFotoLokasiPage(
      {Key? key, required this.dataPelanggan, required this.user})
      : super(key: key);

  @override
  _FormFotoLokasiPageState createState() => _FormFotoLokasiPageState();
}

class _FormFotoLokasiPageState extends State<FormFotoLokasiPage> {
  bool isLoading = false;
  bool isUploadLoading = false;
  bool isAmbilFoto1 = false;
  bool isAmbilFoto2 = false;
  bool isAmbilFoto3 = false;

  String urlFotoLokasi1 = '';
  String urlFotoLokasi2 = '';
  String urlFotoLokasi3 = '';

  final ImagePicker _imagePicker = ImagePicker();
  late File fotoLokasi;
  late String pathFotoLokasi;

  @override
  void initState() {
    print(widget.dataPelanggan);
    getUrlFotoLokasi();
    super.initState();
  }

  Future<void> getFotoLokasi(String idFoto) async {
    final cameras = await availableCameras();

    Navigator.pushReplacement(
      context,
      PageTransition(
        child: TakePicturePage(
          camera: cameras.first,
          user: widget.user,
          idFoto: idFoto,
          dataPelanggan: widget.dataPelanggan,
        ),
        type: PageTransitionType.rightToLeft,
      ),
    );
  }

  Future<void> getUrlFotoLokasi() async {
    setState(() {
      isLoading = true;
    });

    DateTime today = DateTime.now();
    String tglPresensi = "${today.day}-${today.month}-${today.year}";

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection("list_presensi")
        .doc("$tglPresensi")
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
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

  Future<void> getFotoLokasiGalery() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      if (image != null) {
        fotoLokasi = File(image.path);
        pathFotoLokasi = image.path;
      }
    });
    print("TESTING PATH GET FROM GALLERY");
    print(pathFotoLokasi);
  }

  // Future<Position> _getCurrentPosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }

  //   return await Geolocator.getCurrentPosition();
  // }

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
          "Ambil Foto Lokasi",
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
              buildDataImagePasien("foto_lokasi_1", isAmbilFoto1),
              buildDataImagePasien("foto_lokasi_2", isAmbilFoto2),
              buildDataImagePasien("foto_lokasi_3", isAmbilFoto3),
              SizedBox(
                height: 10.h,
              ),
              (isUploadLoading)
                  ? Container(
                      padding: EdgeInsets.all(8),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      height: 56,
                      child: Stack(
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.white,
                            highlightColor: abuTua,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4)),
                              height: 80,
                              width: double.infinity,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Uploading Data",
                              style: fontStyle1.copyWith(
                                color: abuTua,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        if (!isUploadLoading) {
                          setState(() {
                            isUploadLoading = true;
                          });

                          DateTime today = DateTime.now();
                          String tglPresensi =
                              "${today.day}-${today.month}-${today.year}";

                          // Position position = await _getCurrentPosition();

                          Map<String, dynamic> dataPelanggan =
                              widget.dataPelanggan;

                          dataPelanggan.addAll({
                            "bulanKerja": today.month,
                          });

                          // dataPelanggan.addAll({
                          //   "koordinatX": position.latitude,
                          //   "koordinatY": position.longitude,
                          // });

                          
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(widget.user.uid)
                              .collection("list_presensi")
                              .doc("$tglPresensi")
                              .update(dataPelanggan);

                          Navigator.pushAndRemoveUntil(
                            context,
                            PageTransition(
                              child: HomePegawaiPage(user: widget.user),
                              type: PageTransitionType.rightToLeft,
                            ),
                            (route) => false,
                          );

                          setState(() {
                            isUploadLoading = false;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Upload Data",
                          style: fontStyle1.copyWith(
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: abuTua,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDataImagePasien(String idFoto, bool isAmbilFoto) {
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
                              size: 50,
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
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4, right: 12),
                  child: AnimatedCrossFade(
                    firstChild: (!isAmbilFoto)
                        ? ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (idFoto == "foto_lokasi_1") {
                                  isAmbilFoto1 = !isAmbilFoto1;
                                } else if (idFoto == "foto_lokasi_2") {
                                  isAmbilFoto2 = !isAmbilFoto2;
                                } else if (idFoto == "foto_lokasi_3") {
                                  isAmbilFoto3 = !isAmbilFoto3;
                                }
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: abuTua,
                            ),
                            child: Text(
                              "Ambil Foto",
                              style: TextStyle(fontSize: 12, letterSpacing: 1),
                            ),
                          )
                        : Container(),
                    secondChild: (isAmbilFoto)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  print(idFoto);
                                  if (idFoto == "foto_lokasi_1") {
                                    getFotoLokasi("foto_lokasi_1");
                                  } else if (idFoto == "foto_lokasi_2") {
                                    getFotoLokasi("foto_lokasi_2");
                                  } else if (idFoto == "foto_lokasi_3") {
                                    getFotoLokasi("foto_lokasi_3");
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: abuTua,
                                ),
                                child: Text(
                                  "Camera",
                                  style:
                                      TextStyle(fontSize: 12, letterSpacing: 1),
                                ),
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await getFotoLokasiGalery();

                                  setState(() {
                                    isAmbilFoto1 = false;
                                    isAmbilFoto2 = false;
                                    isAmbilFoto3 = false;
                                  });

                                  DateTime today = DateTime.now();
                                  String tglPresensi =
                                      "${today.day}-${today.month}-${today.year}";

                                  final CollectionReference collectionUser =
                                      FirebaseFirestore.instance
                                          .collection("users");

                                  if (idFoto == "foto_lokasi_1") {
                                    print("TEST");
                                    //upload ke firebase
                                    final firebase_storage
                                        .Reference storageRef = firebase_storage
                                                .FirebaseStorage
                                            .instanceFor(
                                                bucket:
                                                    'gs://pln-bali-c4058.appspot.com')
                                        .ref()
                                        .child("${widget.user.email}")
                                        .child("foto_lokasi_1.png");

                                    try {
                                      print("Proses upload foto lokasi 1");

                                      await storageRef.putData(
                                          fotoLokasi.readAsBytesSync());

                                      String urlDownload =
                                          await storageRef.getDownloadURL();

                                      await collectionUser
                                          .doc(widget.user.uid)
                                          .collection("list_presensi")
                                          .doc(tglPresensi)
                                          .update({
                                        'urlFotoLokasi1': urlDownload,
                                      }).then((value) async {
                                        await getUrlFotoLokasi();
                                      });
                                    } catch (e) {
                                      print(e);
                                    }
                                  } else if (idFoto == "foto_lokasi_2") {
                                    //upload ke firebase
                                    final firebase_storage
                                        .Reference storageRef = firebase_storage
                                                .FirebaseStorage
                                            .instanceFor(
                                                bucket:
                                                    'gs://pln-bali-c4058.appspot.com')
                                        .ref()
                                        .child("${widget.user.email}")
                                        .child("foto_lokasi_2.png");

                                    try {
                                      print("Proses upload foto lokasi 2");

                                      await storageRef.putData(
                                          fotoLokasi.readAsBytesSync());

                                      String urlDownload =
                                          await storageRef.getDownloadURL();

                                      await collectionUser
                                          .doc(widget.user.uid)
                                          .collection("list_presensi")
                                          .doc(tglPresensi)
                                          .update({
                                        'urlFotoLokasi2': urlDownload,
                                      }).then((value) async {
                                        await getUrlFotoLokasi();
                                      });
                                    } catch (e) {
                                      print(e);
                                    }
                                  } else if (idFoto == "foto_lokasi_3") {
                                    //upload ke firebase
                                    final firebase_storage
                                        .Reference storageRef = firebase_storage
                                                .FirebaseStorage
                                            .instanceFor(
                                                bucket:
                                                    'gs://pln-bali-c4058.appspot.com')
                                        .ref()
                                        .child("${widget.user.email}")
                                        .child("foto_lokasi_3.png");

                                    try {
                                      print("Proses upload foto lokasi 3");

                                      await storageRef.putData(
                                          fotoLokasi.readAsBytesSync());

                                      String urlDownload =
                                          await storageRef.getDownloadURL();

                                      await collectionUser
                                          .doc(widget.user.uid)
                                          .collection("list_presensi")
                                          .doc(tglPresensi)
                                          .update({
                                        'urlFotoLokasi3': urlDownload,
                                      }).then((value) async {
                                        await getUrlFotoLokasi();
                                      });
                                    } catch (e) {
                                      print(e);
                                    }
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: abuTua,
                                ),
                                child: Text(
                                  "Galery",
                                  style:
                                      TextStyle(fontSize: 12, letterSpacing: 1),
                                ),
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (idFoto == "foto_lokasi_1") {
                                      isAmbilFoto1 = !isAmbilFoto1;
                                    } else if (idFoto == "foto_lokasi_2") {
                                      isAmbilFoto2 = !isAmbilFoto2;
                                    } else if (idFoto == "foto_lokasi_3") {
                                      isAmbilFoto3 = !isAmbilFoto3;
                                    }
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: abuTua,
                                ),
                                child: Text(
                                  "X",
                                  style:
                                      TextStyle(fontSize: 12, letterSpacing: 1),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    crossFadeState: (!isAmbilFoto)
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: Duration(milliseconds: 300),
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
