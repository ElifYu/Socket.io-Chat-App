import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class OwnMessageCard extends StatelessWidget {
  const OwnMessageCard({Key key, this.message, this.time}) : super(key: key);
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                Color(0xFFFF1DB0),
                Color(0xFFE3229F),
                Color(0xFFE3229F),
                Color(0xFFFF1DB0).withOpacity(0.8),
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
                    fontSize: 16
                ),),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(time.toString(), style: TextStyle(
                        fontSize: 13,
                        color: Colors.white
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
