import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListTileForProfile extends StatelessWidget {
  String title;
  Widget leadingIcon;
  Widget trailing;
  Function() ontap = (){};


  ListTileForProfile(

      {required this.title,
        required this.leadingIcon,
        required this.trailing,
        required this.ontap,
        super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        ListTile(
          title: Text(title , textDirection: TextDirection.rtl ,style: TextStyle(
              fontSize: screenWidth*0.038

          ),),
          leading: leadingIcon,
          trailing: trailing,
          contentPadding:  EdgeInsets.symmetric(horizontal:screenWidth * 0.075),
          onTap: ontap,
        ),
        Divider(thickness: 0.5,
          height: 0.2,
          indent: screenWidth * 0.1, // 10% of screen width for indent
          endIndent: screenWidth * 0.1, ),
      ],
    );
  }
}
