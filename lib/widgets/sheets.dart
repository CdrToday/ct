import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:cdr_today/navigations/args.dart';

class EditBottomSheet extends StatelessWidget {
  final Widget cButton = BlocBuilder<CommunityBloc, CommunityState>(
    builder: (context, state) {
      return IconButton(
        icon: Icon(Icons.mode_edit),
        onPressed: () {
          Navigator.pushNamed(
            context, '/user/edit',
            arguments: ArticleArgs(
              community: (state as CommunityFetchedSucceed).current, edit: false
            )
          );
        },
        color: Colors.black,
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
