import 'package:flutter/material.dart';

class ChatModel{
  String name;
  String icon;
  bool isGroup;
  String time;
  String currentMessage;
  String status;
  bool select = false;
  int id;
  ChatModel({
    this.name,
    this.currentMessage,
    this.icon,
    this.isGroup,
    this.status,
    this.select = false,
    this.id,
    this.time});


}