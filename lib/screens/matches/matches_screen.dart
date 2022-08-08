import 'package:flutter/material.dart';
import 'package:travel_mate/widgets/custom_appbar.dart';

class MatchesScreen extends StatelessWidget {
  static const String routeName = '/matches';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => MatchesScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'MATCHES'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'Your Matches',
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(
                height: 100,
                //child: ListView.builder(itemCount: ,),
              )
            ],
          ),
        ),
      ),
    );
  }
}
