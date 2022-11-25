import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ReplyCard extends StatelessWidget {
  const ReplyCard({Key key, this.message, this.time}) : super(key: key);
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Container(

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                Color(0xFFF5F5F5),
                Color(0xFFE2E5DE),
                Color(0xFFE2E5DE),
              ],
              begin: Alignment.topCenter,
            ),
          ),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, right: 60, top: 5, bottom: 20),
                child: Text(message.toString(), style: TextStyle(
                    fontSize: 16,
                  color: Colors.black
                ),),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(time.toString(), style: TextStyle(
                        fontSize: 13,
                        color: Colors.black
                    ),),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
