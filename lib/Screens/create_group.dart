import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:socketio_chat_app/CustomUI/button_card.dart';
import 'package:socketio_chat_app/CustomUI/contact_card.dart';
import 'package:socketio_chat_app/Model/chat_model.dart';

import '../CustomUI/avatar_card.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key key, this.chatModel}) : super(key: key);
  final ChatModel chatModel;

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {


  List<ChatModel> chats = [
    ChatModel(
      name: "Dev Stack",
      status: "A full stack developer",
      id: 2
    ),
    ChatModel(
      name: "Dev Stack",
      status: "A full stack developer",
      id: 3
    ),
  ];

  List<ChatModel> groups = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("New Group", style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold
              ),),
              Text("Add participants", style: TextStyle(
                fontSize: 13,
              ),)
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search, size: 26,),
              onPressed: (){},
            ),

          ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: groups.length > 0 ? Column(
                children: [
                   Container(
                    height: 75,
                    color: Colors.white,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: chats.length,
                      itemBuilder: (BuildContext context, int index) {
                       if(chats[index].select == true)  {
                         return InkWell(
                           onTap: (){
                             setState(() {
                               groups.remove(chats[index]);
                               chats[index].select = false;
                             });
                           },
                             child: AvatarCard(chatModel: chats[index],));
                       }
                       else {
                         return Container();
                       }
                      }
                    ),
                  ),
                  Divider(
                    thickness: 1,
                  )
                ],
              ) : Container(),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                if(index == 0){
                  return Container(
                    height: groups.length > 0 ? 0 : 10,
                  );
                }
                return InkWell(
                  onTap: (){
                    if(chats[index - 1].select == false){
                      setState(() {
                        chats[index - 1].select = true;
                        groups.add(chats[index - 1]);
                      });
                    }
                    else{
                      setState(() {
                        chats[index - 1].select = false;
                        groups.remove(chats[index - 1]);
                      });
                    }
                  },
                  child: ContactCard(chatModel: chats[index - 1]));
              },
                childCount: chats.length + 1,
              ),
            ),
          ],
        )
    );
  }
}
