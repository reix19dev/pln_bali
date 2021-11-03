import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pln_bali/utils/colors.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        orientation: Orientation.portrait);
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        color: abuTua,
        child: Center(
          child: Container(
            child: Image.asset("assets/images/logo_putih.png"),
          ),
        ),
      ),
    );
  }
}
