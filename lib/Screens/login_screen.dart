import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:socketio_chat_app/CustomUI/background.dart';
import 'package:socketio_chat_app/CustomUI/button_card.dart';
import 'package:socketio_chat_app/Model/chat_model.dart';
import 'package:socketio_chat_app/Model/users.dart';
import 'package:socketio_chat_app/Screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  ChatModel sourceChat;

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade700.withOpacity(0.2),
          elevation: 0,
          toolbarHeight: 70,
          title: Text('Choose One', style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold
          ),),
        ),
        body: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: chatModels.length,
          itemBuilder: (context, index) => InkWell(
            onTap: (){
             setState(() {
               selectedUser = chatModels[index];
               var delete = chatModels.removeAt(index);
               sourceChat = delete;
             });
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(
                chatModel: chatModels,
                sourceChat: sourceChat,
              )));
            },
            child: ButtonCard(
              name: chatModels[index].name,
              icon: chatModels[index].icon,
              index: index,
              width: 70,
              height: 70,
            ),
          )
        ),
      ),
    );
  }
}
