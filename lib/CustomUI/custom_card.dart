import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:socketio_chat_app/CustomUI/button_card.dart';
import 'package:socketio_chat_app/Model/chat_model.dart';
import 'package:socketio_chat_app/Screens/individual_page.dart';


class CustomCard extends StatelessWidget {
  const CustomCard({Key key, this.chatModel, this.sourceChat, this.index}) : super(key: key);
  final ChatModel chatModel;
  final ChatModel sourceChat;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => IndividualPage(chatModel: chatModel,
        sourceChat: sourceChat,)));
      },
      child: ButtonCard(
          index: index,
          name: chatModel.name,
          icon: chatModel.icon,
          width: 50,
          height: 50
      ),
    );
  }
}


class CustomCardHomePage extends StatelessWidget {
  const CustomCardHomePage({Key key, this.chatModel, this.sourceChat, this.index}) : super(key: key);
  final ChatModel chatModel;
  final ChatModel sourceChat;
  final int index;

  @override
  Widget build(BuildContext context) {
    return  ButtonCard(
          index: index,
          name: chatModel.name,
          icon: chatModel.icon,
          width: 50,
          height: 50
    );
  }
}