import 'package:elearning/utils/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class HeaderInner extends StatelessWidget {
  const HeaderInner({super.key});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(50.0)),
              color: Constants.blueLight,
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: -100,
                  right: -130,
                  child: Image.asset("assets/images/blob_2.png",
                      width: 352,
                      height: 343,
                      color: Constants.blueDark),
                ),
                Positioned(
                  top: 20,
                  left: -100,
                  child: Image.asset("assets/images/blob_1.png",
                      width: 302,
                      height: 343,
                      color: Constants.blueMain),
                ),
              ],
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: Container()
        )
      ],
    );
  }
}