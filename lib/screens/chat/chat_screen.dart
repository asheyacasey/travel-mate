import 'package:flutter/material.dart';

import '../../models/user_match_model.dart';

class ChatScreen extends StatelessWidget {
  static const String routeName = '/chat';

  static Route route({required UserMatch userMatch}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => ChatScreen(userMatch: userMatch),
    );
  }

  final UserMatch userMatch;

  const ChatScreen({required this.userMatch});


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
