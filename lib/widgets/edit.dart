import 'package:flutter/material.dart';

// editTitle
class TitleWidget extends StatelessWidget {
  final void Function(String text) onChanged;
  final TextEditingController titleController;

  TitleWidget({ this.onChanged, this.titleController });
  
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w700
      ),
      decoration: InputDecoration(
        hintText: '标题',
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      scrollPadding: EdgeInsets.all(20.0),
      controller: titleController,
      onChanged: onChanged
    );
  }
}

class ContentWidget extends StatelessWidget {
  final void Function(String text) onChanged;
  final TextEditingController contentController;

  ContentWidget({ this.onChanged, this.contentController });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: '内容',
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      keyboardType: TextInputType.multiline,
      maxLines: null,
      controller: contentController,
      onChanged: onChanged
    );
  }
}
