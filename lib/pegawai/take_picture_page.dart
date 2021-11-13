import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pln_bali/pegawai/form_foto_lokasi.dart';
import 'package:pln_bali/utils/colors.dart';
import 'package:pln_bali/utils/font_styles.dart';
import 'package:shimmer/shimmer.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class TakePicturePage extends StatefulWidget {
  final CameraDescription camera;
  final String idFoto;
  final User user;
  final Map<String, dynamic> dataPelanggan;

  const TakePicturePage({
    Key? key,
    required this.camera,
    required this.user,
    required this.idFoto,
    required this.dataPelanggan,
  }) : super(key: key);

  @override
  TakePicturePageState createState() => TakePicturePageState();
}

class TakePicturePageState extends State<TakePicturePage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(32, 56, 32, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "Harap Mengambil Foto secara landscape",
                      style: fontStyle1.copyWith(
                        color: abuTua,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: abuTua,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CameraPreview(
                          _controller,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: abuTua,
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            _controller.setFlashMode(FlashMode.off);
            final image = await _controller.takePicture();
            print("alamat file");
            print(image.path);
            await Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: image.path,
                  idFoto: widget.idFoto,
                  user: widget.user,
                  dataPelanggan: widget.dataPelanggan,
                ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(
          Icons.camera_alt,
        ),
      ),
    );
  }
}

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final String idFoto;
  final User user;
  final Map<String, dynamic> dataPelanggan;

  const DisplayPictureScreen({
    Key? key,
    required this.imagePath,
    required this.user,
    required this.idFoto,
    required this.dataPelanggan,
  }) : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 56, 32, 32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.file(
                File(widget.imagePath),
                fit: BoxFit.fill,
                frameBuilder: (BuildContext context, Widget child, int? frame,
                    bool wasSynchronouslyLoaded) {
                  return wasSynchronouslyLoaded
                      ? child
                      : AnimatedOpacity(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: child,
                            ),
                          ),
                          opacity: frame == null ? 0 : 1,
                          duration: const Duration(seconds: 2),
                          curve: Curves.easeOut,
                        );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "Pastikan anda telah mengambil gambar dengan jelas sebelum mengupload gambar.",
                  style: fontStyle1.copyWith(
                    color: abuTua,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              (_isLoading)
                  ? Container(
                      padding: EdgeInsets.all(8),
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
                              "Uploading...",
                              style: fontStyle1.copyWith(
                                color: abuTua,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final cameras = await availableCameras();

                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                child: TakePicturePage(
                                  camera: cameras.first,
                                  user: widget.user,
                                  idFoto: widget.idFoto,
                                  dataPelanggan: widget.dataPelanggan,
                                ),
                                type: PageTransitionType.rightToLeft,
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: abuTua,
                          ),
                          child: Text(
                            "Foto Ulang",
                            style: TextStyle(fontSize: 12, letterSpacing: 1),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });

                            DateTime today = DateTime.now();
                            String tglPresensi =
                                "${today.day}-${today.month}-${today.year}";

                            print("Uploading Process Started");

                            final firebase_storage.Reference storageRef =
                                firebase_storage.FirebaseStorage.instanceFor(
                                        bucket:
                                            'gs://pln-bali-c4058.appspot.com')
                                    .ref()
                                    .child("${widget.user.email}")
                                    .child("${widget.idFoto}.png");

                            final CollectionReference collectionUser =
                                FirebaseFirestore.instance.collection("users");

                            if (widget.idFoto == "foto_lokasi_1") {
                              try {
                                print("Proses upload lokasi 1");

                                await storageRef.putData(
                                    File(widget.imagePath).readAsBytesSync());

                                String urlDownload =
                                    await storageRef.getDownloadURL();

                                await collectionUser
                                    .doc(widget.user.uid)
                                    .collection("list_presensi")
                                    .doc("$tglPresensi")
                                    .update({
                                  'urlFotoLokasi1': urlDownload,
                                });
                              } catch (e) {
                                print(e);
                              }
                            } else if (widget.idFoto == "foto_lokasi_2") {
                              try {
                                print("Proses upload lokasi 2");

                                await storageRef.putData(
                                    File(widget.imagePath).readAsBytesSync());

                                String urlDownload =
                                    await storageRef.getDownloadURL();

                                await collectionUser
                                    .doc(widget.user.uid)
                                    .collection("list_presensi")
                                    .doc("$tglPresensi")
                                    .update({
                                  'urlFotoLokasi2': urlDownload,
                                });
                              } catch (e) {
                                print(e);
                              }
                            } else if (widget.idFoto == "foto_lokasi_3") {
                              try {
                                print("Proses upload lokasi 3");

                                await storageRef.putData(
                                    File(widget.imagePath).readAsBytesSync());

                                String urlDownload =
                                    await storageRef.getDownloadURL();

                                await collectionUser
                                    .doc(widget.user.uid)
                                    .collection("list_presensi")
                                    .doc("$tglPresensi")
                                    .update({
                                  'urlFotoLokasi3': urlDownload,
                                });
                              } catch (e) {
                                print(e);
                              }
                            }

                            print("Uploading Process Ended");

                            setState(() {
                              _isLoading = false;
                            });

                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                child: FormFotoLokasiPage(
                                    dataPelanggan: widget.dataPelanggan,
                                    user: widget.user),
                                type: PageTransitionType.rightToLeft,
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: abuTua,
                          ),
                          child: Text(
                            "Upload",
                            style: TextStyle(fontSize: 12, letterSpacing: 1),
                          ),
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
