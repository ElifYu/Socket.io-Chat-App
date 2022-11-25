import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:socketio_chat_app/Model/chat_model.dart';

class AvatarCard extends StatelessWidget {
  const AvatarCard({Key key, this.chatModel}) : super(key: key);
  final ChatModel chatModel;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 23,
                child: LineIcon.user(color: Colors.white),
                backgroundColor: Colors.blueGrey.shade200,
              ),
               Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 11,
                    child: Icon(Icons.clear, color: Colors.white, size: 18,)),
              ),
            ],
          ),
          SizedBox(height: 2),
          Text(chatModel.name.toString(), style: TextStyle(
            fontSize: 12
          ),),
        ],
      ),
    );
  }
}
