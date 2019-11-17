import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/navigations/args.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:cdr_today/widgets/buttons.dart';

class ProfileCard extends StatelessWidget {
  @override
  build(BuildContext context) {
    return Container(
      child: Row(
        children:[
          Spacer(),
          AvatarHero(
            width: 38.0,
            self: true,
            onTap: () => Navigator.pushNamed(
              context, '/mine/profile'
            ),
          ),
          Spacer(),
        ]
      ),
      height: MediaQuery.of(context).size.height  / 3
    );
  }
}
