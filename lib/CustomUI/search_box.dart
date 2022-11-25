import 'package:flutter/material.dart';

class SearchBox {
  static Widget searchBox(context, {
    Function onTap,
    Function onChange,
    TextEditingController controller
  }) {
    return Container(
      height: 45,
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: TextField(
        controller: controller ?? TextEditingController(),
        onTap: () => onTap(),
        onChanged: (value) => onChange(value),
        decoration: InputDecoration(
          filled: true,

          fillColor: Colors.grey[700].withOpacity(0.3),
          hintText: 'Search',
          prefixIcon: Icon(Icons.search),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade800,),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade800),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static Widget searchBoxCustom(context, {
    TextEditingController controller
  }) {
    return Row(
      children: [
        Expanded(child: searchBox(context, controller: controller)),
        controller.text.isEmpty ? Container() :
        TextButton(
          style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size(50, 30),
              alignment: Alignment.centerRight),
          child: Text('Cancel'),
          onPressed: (){
            controller.clear();
          },
        )
      ],
    );
  }
}

