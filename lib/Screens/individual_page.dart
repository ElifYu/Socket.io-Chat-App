//@dart=2.9
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icon.dart';
import 'package:socketio_chat_app/CustomUI/background.dart';
import 'package:socketio_chat_app/CustomUI/own_file_card.dart';
import 'package:socketio_chat_app/CustomUI/reply_card.dart';
import 'package:socketio_chat_app/CustomUI/reply_file_card.dart';
import 'package:socketio_chat_app/Model/chat_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socketio_chat_app/Model/message_model.dart';
import 'package:socketio_chat_app/Screens/camera_screen.dart';
import 'package:socketio_chat_app/Screens/camera_view.dart';
import '../CustomUI/own_message_card.dart';
import 'package:http/http.dart' as http;

List<MessageModel> messages = [];

class IndividualPage extends StatefulWidget {
  const IndividualPage({Key key, this.chatModel, this.sourceChat, this.removeArrowButton = false}) : super(key: key);

  final ChatModel chatModel;
  final ChatModel sourceChat;
  final bool removeArrowButton;

  @override
  State<IndividualPage> createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  bool show = false;
  FocusNode focusNode = FocusNode();
  bool sendButton = false;

  File file;
  int popTime = 0;

  IO.Socket socket;

  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();

  void connect() {
    socket = IO.io("http://192.168.1.43:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false
    });
    socket.connect();
    socket.emit("signin", widget.sourceChat.id);
    socket.onConnect((data) {
      print(data);

    });
    socket.on("message", (msg) {
      print(msg);
      setMessage("destination", msg["message"], msg["path"]);
      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    });
    print(socket.json.toString());
  }

  void sendMessage(String message, int sourceId, int targetId, String path){
    setMessage("source", message, path);
    socket.emit("message", {"message": message, "sourceId": sourceId, "targetId": targetId, "path": path});
  }

  void setMessage(String type, String message, String path){
    MessageModel messageModel = MessageModel(type: type, message: message, time: DateTime.now().toString().substring(10, 16),
        path: path );
    setState(() {
      messages.add(messageModel);
    });
  }

  void sendImageSend(String path, String message) async{
    print(path);
    for(int i = 0; i < popTime; i++){
      Navigator.pop(context);
      setState(() {
        popTime = 1;
      });
    }

    var request = http.MultipartRequest("POST", Uri.parse("http://192.168.1.43:5000/routes/addimage"));
    request.files.add(await http.MultipartFile.fromPath("img", path));
    request.headers.addAll({
      "Content-type": "multipart/form-data"
    });
    http.StreamedResponse response = await request.send();
    var httpResponse = await http.Response.fromStream(response);
    var data = json.decode(httpResponse.body);
    setMessage("source", message, path);
    print(httpResponse.body);
    socket.emit("message", {
      "message": message,
      "sourceId": widget.sourceChat.id,
      "targetId": widget.chatModel.id,
      "path": data['path']});

    _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(seconds: 3), curve: Curves.easeOut);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.sourceChat.id);
    print(widget.chatModel.id);
    connect();
    focusNode.addListener(() {
      if(focusNode.hasFocus){
        setState(() {
          show = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey.shade800.withOpacity(0.2),
          leadingWidth: 70,
          toolbarHeight: 70,
          titleSpacing: 0,
          actions: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("• Online", style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.greenAccent
                    ),),
                    Text(widget.chatModel.name.toString(), style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15
                    ),),
                  ],
                ),
                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFE3229F), width: 2),
                    borderRadius: BorderRadius.circular(40)
                  ),
                  padding: EdgeInsets.all(3),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(widget.chatModel.icon.toString()),
                  ),
                ),
                SizedBox(width: 15),
              ],
            )
          ],
          automaticallyImplyLeading: widget.removeArrowButton,
          leading: widget.removeArrowButton ?
          Text("") :
          IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20,),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: WillPopScope(
            child: Column(
              children: [
                Expanded(
                  //height: MediaQuery.of(context).size.height - 140,
                    child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: messages.length + 1,
                        itemBuilder: (context, index){
                          if(index == messages.length){
                            return Container(height: 70);
                          }
                          if(messages[index].type == "source") {
                            if(messages[index].path.length > 0) {
                              return OwnFileCard(path: messages[index].path,
                                message: messages[index].message,
                                time: messages[index].time,);
                            }
                            else{
                              return OwnMessageCard(
                                message: messages[index].message,
                                time: messages[index].time,
                              );
                            }
                          }
                          else {
                            if(messages[index].path.length > 0) {
                              return OwnReplyFileCard(
                                path: messages[index].path,
                                message: messages[index].message,
                                time: messages[index].time,
                              );
                            }
                            else{
                              return ReplyCard(
                                message: messages[index].message,
                                time: messages[index].time,
                              );
                            }
                          }
                        }
                    )

                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 70,
                    margin: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Expanded(

                                child: Card(
                                  elevation: 3,
                                  color: Colors.grey[800].withOpacity(0.3),
                                    margin: EdgeInsets.only(left: 2, right: 2, bottom: 8),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25)
                                    ),
                                    child: TextFormField(
                                      controller: _controller,
                                      focusNode: focusNode,
                                      textAlignVertical: TextAlignVertical.center,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 5,
                                      minLines: 1,
                                      onChanged: (value){
                                        if(value.length > 0) {
                                          setState(() {
                                            sendButton = true;
                                          });
                                        }
                                        else{
                                          setState(() {
                                            sendButton = false;
                                          });
                                        }
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          suffixIcon: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.insert_photo),
                                                onPressed: () async{
                                                  setState(() {
                                                    popTime = 2;
                                                  });
                                                  ImagePicker _picker = ImagePicker();

                                                  var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                                                  setState(() {
                                                    file = File(image.path); // won't have any error now
                                                  });
                                                  if(file.path != null)
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => CameraViewPage(path: file.path,
                                                    onSend: sendImageSend,)));

                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.camera_alt),
                                                onPressed: (){
                                                  setState(() {
                                                    popTime = 2;
                                                  });
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen(
                                                    onImageSend: sendImageSend,
                                                  )));
                                                },
                                              ),
                                            ],
                                          ),
                                          hintText: "Type a message",
                                          prefixIcon: IconButton(
                                            icon: Icon(Icons.emoji_emotions),
                                            onPressed: () async{
                                              focusNode.unfocus();
                                              await Future.delayed(Duration(milliseconds: 500));
                                              focusNode.canRequestFocus = false;
                                              setState(() {
                                                show = !show;
                                              });
                                            },
                                          ),
                                          contentPadding: EdgeInsets.all(5)
                                      ),
                                    ))),
                            Padding(
                              padding: EdgeInsets.only(bottom: 8, right: 2, left: 2),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Color(0xFFE3229F),

                                child: IconButton(
                                  icon: Icon(Icons.send, color: Colors.white,),
                                  onPressed: (){
                                    if(sendButton){
                                      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                                      sendMessage(_controller.text, widget.sourceChat.id, widget.chatModel.id, "");
                                      _controller.clear();
                                      setState(() {
                                        sendButton = false;
                                      });
                                    }
                                  },
                                ),
                              ),
                            )
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
                show ? emojiSelect() : Container()
              ],
            ),
            onWillPop: (){
              if(show){
                setState(() {
                  show = false;
                });
              }
              else{
                Navigator.pop(context);
              }
              return Future.value(false);
            },
          ),
        ),
      ),
    );
  }

  Widget emojiSelect(){
    return EmojiPicker(
      rows: 4,
      columns: 7,
      onEmojiSelected: (emoji, category){
        print(emoji);
        setState(() {
          _controller.text = _controller.text + emoji.emoji;
        });
      },
    );
  }



}

