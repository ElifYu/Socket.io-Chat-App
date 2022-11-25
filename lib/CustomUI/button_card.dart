import 'package:flutter/material.dart';

class ButtonCard extends StatelessWidget {
  const ButtonCard({Key key, this.name, this.icon, this.index, this.height, this.width}) : super(key: key);
  final String name;
  final String icon;
  final int index;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: index == 0 ? EdgeInsets.only(left: 5, right: 5, bottom: 7, top: 10)
          : EdgeInsets.only(left: 5, right: 5, bottom: 7, top: 7),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.03),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color:  Colors.grey.shade900.withOpacity(0.2),
                image: DecorationImage(
                  image: NetworkImage(icon),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all( Radius.circular(50.0)),
                border: Border.all(
                  color: Color(0xFFE3229F).withOpacity(0.3),
                  width: 4.0,
                ),
              ),
            ),

            SizedBox(width: 14),
            Expanded(
              child: Text(name.toString(), style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500
              ),),
            ),
            Icon(Icons.arrow_forward_ios, size: 17, color: Colors.grey.withOpacity(0.4),)
          ],
        ),
      ),
    );
  }
}
