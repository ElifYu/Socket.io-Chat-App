import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CameraViewPage extends StatefulWidget {
  const CameraViewPage({Key key, this.path, this.onSend}) : super(key: key);
  final String path;
  final Function onSend;

  @override
  State<CameraViewPage> createState() => _CameraViewPageState();
}

class _CameraViewPageState extends State<CameraViewPage> {

  static TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 150,
              child: kIsWeb ?
              Image.network(widget.path) :
              Image.file(File(widget.path), fit: BoxFit.cover,),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                color: Colors.black38,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: TextFormField(
                  controller: controller,
                  maxLines: 6,
                  minLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Add Caption",
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 17
                    ),
                    prefixIcon: Icon(Icons.short_text_outlined, color: Colors.black, size: 27,),
                    suffixIcon: InkWell(
                      onTap: (){
                        print(widget.path+'.jpg');
                        widget.onSend(widget.path, controller.text.trim());
                      },
                      child: CircleAvatar(
                        radius: 27,
                        backgroundColor: Color(0xFFE3229F),
                        child: Icon(Icons.check, color: Colors.white,),
                      ),
                    )
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
