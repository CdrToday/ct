import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:cdr_today/navigations/args.dart';

class EditBottomSheet extends StatelessWidget {
  final Widget cButton = BlocBuilder<CommunityBloc, CommunityState>(
    builder: (context, state) {
      return Padding(
        child: GestureDetector(
          child: Icon(
            Icons.mode_edit,
            color: Colors.black
          ),
          onTap: () {
            showCupertinoModalPopup(
              context: context,
              builder: (context) => CupertinoActionSheet(
                actions: [
                  CupertinoActionSheetAction(
                    child: Text('图片'),
                    onPressed: () async {
                    }
                  ),
                  CupertinoActionSheetAction(
                    child: Text('文字'),
                    onPressed: () async {
                      Navigator.popAndPushNamed(
                        context, '/user/edit',
                        arguments: ArticleArgs()
                      );
                    }
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: Text('取消'),
                  onPressed: () => Navigator.pop(context),
                )
              )
            );
          },
          onLongPress: () {
            Navigator.pushNamed(context, '/scan');
          },
        ),
        padding: EdgeInsets.only(right: 12.0)
      );
    }
  );
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [SizedBox.shrink(), cButton],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
      alignment: AlignmentDirectional.centerEnd,
      constraints: BoxConstraints(maxHeight: 42.0),
      decoration: BoxDecoration(color: Colors.grey[200])
    );
  }
}
