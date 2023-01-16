import 'package:flutter/material.dart';
import 'package:makuuygulama/consts/tanitim_consts.dart';

class UygulamaTanitim extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.blue,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  TanitimConst.hakkimizda,
                  style: buildTextStyle(context, size: 25, renk: Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  TanitimConst.hakkimizdaaciklama,
                  style: buildTextStyle(context),
                ),
                SizedBox(height: 20),
                Text(TanitimConst.baslik1,
                    style:
                        buildTextStyle(context, size: 25, renk: Colors.white)),
                SizedBox(height: 20),
                Text(TanitimConst.baslik1aciklama1,
                    style:
                        buildTextStyle(context, size: 35, renk: Colors.yellow)),
                SizedBox(height: 20),
                Text(TanitimConst.baslik1aciklama2,
                    style:
                        buildTextStyle(context, size: 35, renk: Colors.yellow)),
                SizedBox(height: 20),
                Text(
                    "Okulumuz hakkında daha fazla bilgi için web sayfamızı ziyaret ediniz",
                    style:
                        buildTextStyle(context, size: 35, renk: Colors.purple)),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle buildTextStyle(BuildContext context,
      {int size = 30, Color renk = Colors.yellow}) {
    return TextStyle(
      color: renk,
      fontSize: MediaQuery.of(context).size.height / size,
    );
  }
}
