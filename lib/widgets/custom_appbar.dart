import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
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
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Container(
        child: SvgPicture.asset(
          'assets/logo.svg',
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(title, style: Theme.of(context).primaryTextTheme.headline2),
        actions: hasAction
          ? [
              IconButton(
                 onPressed: () {},
                 icon: Icon(
                  FeatherIcons.messageCircle,
                    color: Theme.of(context).primaryColor,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    FeatherIcons.user,
                    color: Theme.of(context).primaryColor,
                 )),
           ]
         : null,

      // backgroundColor: Colors.transparent,
      // elevation: 0,
      // title: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     Expanded(
      //         child: SvgPicture.asset(
      //       'assets/logo.svg',
      //       height: 90,
      //     )),
      //     Expanded(
      //         flex: 2,
      //         child: Text(
      //           title,
      //           style: Theme.of(context).textTheme.headline2,
      //         )),
      //   ],
      // ),
      // actions: hasAction
      //     ? [
      //         IconButton(
      //             onPressed: () {},
      //             icon: Icon(
      //               Icons.person,
      //               color: Theme.of(context).primaryColor,
      //             )),
      //         IconButton(
      //             onPressed: () {},
      //             icon: Icon(
      //               Icons.message,
      //               color: Theme.of(context).primaryColor,
      //             )),
      //       ]
      //     : null,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);
}
