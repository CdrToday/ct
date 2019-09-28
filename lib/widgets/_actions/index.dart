import 'package:flutter/material.dart';
import 'package:cdr_today/navigations/args.dart';

enum ActionX {
  scan,
  edit
}

class IndexAction extends StatelessWidget {
  final String community;
  IndexAction({this.community});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.add_circle_outline,
        color: Colors.grey[800]
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ActionX>>[
        PopupMenuItem<ActionX>(
          value: ActionX.scan,
          child: GestureDetector(
            child: Center(
              child: Row(
                children: [
                  Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10.0),
                  Text('扫码', style: TextStyle(color: Colors.white))
                ],
              ),
            ),
          ),
        ),
        PopupMenuItem<ActionX>(
          value: ActionX.edit,
          child: GestureDetector(
            child: Center(
              child: Row(
                children: [
                  Icon(
                    Icons.mode_edit,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10.0),
                  Text('编辑', style: TextStyle(color: Colors.white))
                ],
              ),
            ),
          ),
        ),
      ],
      elevation: 0.0,
      color: Color.fromRGBO(0, 0, 0, .8),
      offset: Offset(20.0, 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0))
      ),
      onSelected: (value) {
        if (value == ActionX.scan) {
          Navigator.pushNamed(context, '/scan');
        } else {
          Navigator.pushNamed(
            context, '/user/edit',
            arguments: community != null ? ArticleArgs(
              community: community
            ) : ArticleArgs()
          );
        }
      }
    );
  }

  List<Widget> toList() => [IndexAction()];
}

