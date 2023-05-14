import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unicons/unicons.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasAction;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.hasAction = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: SvgPicture.asset(
        'assets/logo.svg',
        height: 90,
      ),
      title: Text(
        title,
        style: Theme.of(context).primaryTextTheme.headline2,
      ),
      actions: hasAction
          ? [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/mainJournal');
                  },
                  icon: Icon(
                    UniconsLine.notes,
                    color: Theme.of(context).primaryColor,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/matches');
                  },
                  icon: Icon(
                    UniconsLine.comment,
                    color: Theme.of(context).primaryColor,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  icon: Icon(
                    UniconsLine.user,
                    color: Theme.of(context).primaryColor,
                  )),
            ]
          : null,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);
}
