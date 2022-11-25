import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:socketio_chat_app/Model/chat_model.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({Key key, this.chatModel}) : super(key: key);
  final ChatModel chatModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 53,
        width: 50,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 23,
              child: LineIcon.user(color: Colors.white),
              backgroundColor: Colors.blueGrey.shade200,
            ),
            chatModel.select ? Positioned(
              bottom: 4,
              right: 5,
              child: CircleAvatar(
                backgroundColor: Colors.teal,
                  radius: 11,
                  child: Icon(Icons.check, color: Colors.white, size: 18,)),
            ) : Container(),
          ],
        ),
      ),
      title: Text(chatModel.name.toString(), style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold
      ),),
      subtitle: Text(chatModel.status.toString(), style: TextStyle(
        fontSize: 13
      ),),
    );
  }
}
