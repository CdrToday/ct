import 'package:flutter/material.dart';
import 'package:cdr_today/navigations/args.dart';

class EditBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          SizedBox.shrink(),
          // IconButton(
          //   icon: Icon(Icons.filter_list),
          //   onPressed: () {
          //     Navigator.pushNamed(
          //       context, '/user/edit',
          //       arguments: ArticleArgs(edit: false)
          //     );
          //   },
          //   color: Colors.black,
          // ),
          IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: () {
              Navigator.pushNamed(
                context, '/user/edit',
                arguments: ArticleArgs(edit: false)
              );
            },
            color: Colors.black,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
      alignment: AlignmentDirectional.centerEnd,
      constraints: BoxConstraints(maxHeight: 42.0),
      decoration: BoxDecoration(color: Colors.grey[200])
    );
  }
}
