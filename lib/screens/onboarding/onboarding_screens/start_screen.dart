import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/widgets.dart';

class Start extends StatelessWidget {
  final TabController tabController;
  const Start({Key? key, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Column(
              children: [
                Container(
                  height: 220,
                  width:220,
                  child: SvgPicture.asset(
                    'assets/start-up-logo.svg',
                  ),
                ),

             //   SizedBox(height: 20),
                Text(
                    'Find your the ONE and make your travel to the next level.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(height: 1.8, color: Colors.blueGrey)),
              ],
            ),
          ),
          CustomButton(tabController: tabController)
        ],
      ),
    );
  }
}
