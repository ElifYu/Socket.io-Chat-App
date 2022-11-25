import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OwnReplyFileCard extends StatelessWidget {
  const OwnReplyFileCard({Key key, this.path, this.message, this.time}) : super(key: key);
  final String path;
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Container(
          width: MediaQuery.of(context).size.width / 4,
          height: MediaQuery.of(context).size.height / 2.3,
          margin: EdgeInsets.all(3),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: kIsWeb ?
                      Image.network("http://localhost:5000/uploads/${path.toString()}", fit: BoxFit.fitHeight,) :
                      Image.file(File("http://localhost:5000/uploads/${path.toString()}"), fit: BoxFit.fitHeight,)),
                ),
              ),
              message.length > 0 ?
              Padding(
                padding: EdgeInsets.only(left: 10, right: 60, top: 5),
                child: Text(message.toString(), style: TextStyle(
                    fontSize: 16,
                    color: Colors.black
                ),),
              ) :
              Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10,bottom: 10),
                    child: Text(time.toString(), style: TextStyle(
                        fontSize: 13,
                        color: Colors.black
                    ),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
