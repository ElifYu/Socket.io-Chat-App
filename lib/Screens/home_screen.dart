import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:socketio_chat_app/CustomUI/background.dart';
import 'package:socketio_chat_app/CustomUI/custom_card.dart';
import 'package:socketio_chat_app/CustomUI/search_box.dart';
import 'package:socketio_chat_app/Model/chat_model.dart';
import 'package:socketio_chat_app/Model/users.dart';
import 'package:socketio_chat_app/Screens/individual_page.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key, this.chatModel, this.sourceChat}) : super(key: key);
  final List<ChatModel> chatModel;
  final ChatModel sourceChat;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{

  TextEditingController controller = TextEditingController();
  List<ChatModel> _foundUsers = [];

  void _runFilter(String enteredKeyword) {
    List<ChatModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results =  widget.chatModel;
    } else {
      results =  widget.chatModel
          .where((user) =>
          user.name.toString().toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  int ind;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // at the beginning, all users are shown
    _foundUsers = widget.chatModel;
  }
  @override
  Widget build(BuildContext context) {
    return Background(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          print(constraints);
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: appBar(),
            body: constraints.maxWidth < 800 ? rightSide(constraints.maxWidth) :
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2.8,
                    height: MediaQuery.of(context).size.height,
                    child: rightSide(constraints.maxWidth)),
                Expanded(
                  child: ind == null ? Center(child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network("https://static.thenounproject.com/png/1473220-200.png", color: Colors.white,),
                        Text("Start messaging with your friends")
                      ],
                    )
                  )) :
                  IndividualPage(
                    chatModel: _foundUsers[ind],
                    sourceChat: widget.sourceChat,
                    removeArrowButton: true
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }
  Widget appBar() {
    return  AppBar(
      backgroundColor: Colors.grey.shade700.withOpacity(0.2),
      elevation: 0,
      centerTitle: false,
      toolbarHeight: 70,
      title: Text('Chats', style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold
      ),),
      actions: [
        Row(
          children: [
            Container(
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("My Profile", style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[500]
                  ), maxLines: 1),
                  Text(selectedUser.name.toString(), style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15
                  ), maxLines: 1),
                ],
              ),
            ),
            SizedBox(width: 10),
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(selectedUser.icon.toString()),
            ),
            SizedBox(width: 15),
          ],
        )
      ],
    );
  }
  Widget rightSide(constraints){
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SearchBox.searchBox(context, onTap: (){}, controller: controller, onChange: (value){
            _runFilter(value);
          }),
        )),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return constraints < 800 ?
              CustomCard(
                index: index,
                chatModel: _foundUsers[index],
                sourceChat: widget.sourceChat,) :
              InkWell(
                onTap: (){
                  setState(() {
                    ind = index;
                    messages.clear();
                  });
                },
                child: CustomCardHomePage(
                  index: index,
                  chatModel: _foundUsers[index],
                  sourceChat: widget.sourceChat,),
              );
            },
            childCount:  _foundUsers.length,
          ),
        ),
      ],
    );
  }
}
