import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_mate/blocs/auth/auth_bloc.dart';
import 'package:travel_mate/blocs/blocs.dart';
import 'package:travel_mate/repositories/database/database_repository.dart';
import 'package:travel_mate/screens/chat/packages_screen.dart';
import 'package:unicons/unicons.dart';
import 'package:travel_mate/models/models.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatelessWidget {
  static const String routeName = '/chat';

  static Route route({required Match match}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => BlocProvider<ChatBloc>(
        create: (context) => ChatBloc(
          databaseRepository: context.read<DatabaseRepository>(),
        )..add(LoadChat(match.chat.id)),
        child: ChatScreen(match: match),
      ),
    );
  }

  final Match match;

  const ChatScreen({Key? key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _CustomAppBar(match: match),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ChatLoaded) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: state.chat.messages.length,
                    itemBuilder: (context, index) {
                      List<Message> messages = state.chat.messages;
                      return ListTile(
                        title: _Message(
                          match: match,
                          message: messages[index].message,
                          messageId: messages[index].messageId,
                          itinerary: messages[index].itinerary,
                          isAccepted: messages[index].itineraryAccept,
                          isFromCurrentUser: messages[index].senderId ==
                              context.read<AuthBloc>().state.authUser!.uid,
                        ),
                      );
                    },
                  ),
                ),
                _MessageInput(match: match),
              ],
            );
          } else {
            return Text('Something went wrong.');
          }
        },
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar({
    Key? key,
    required this.match,
  }) : super(key: key);

  final Match match;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Theme.of(context).backgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      title: Column(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundImage: NetworkImage(match.matchUser.imageUrls[0]),
          ),
          Text(
            match.matchUser.name,
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}

class _MessageInput extends StatelessWidget {
  const _MessageInput({Key? key, required this.match}) : super(key: key);

  final Match match;

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    Map<String, dynamic>? finalOption;
    return Container(
      padding: EdgeInsets.all(5.0),
      child: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Type a message',
                  contentPadding:
                      const EdgeInsets.only(left: 20, bottom: 5, top: 5),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return _buildBottomModal(context, match);
                  },
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
              child: IconButton(
                icon: Icon(UniconsLine.message),
                onPressed: () {
                  String uuid = new Uuid().v4();
                  context.read<ChatBloc>()
                    ..add(
                      AddMessage(
                        userId: match.userId,
                        matchUserId: match.matchUser.id!,
                        message: controller.text,
                        messageId: uuid,
                        itinerary: finalOption,
                      ),
                    );
                  controller.clear();
                },
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildBottomModal(BuildContext context, Match match) {
  int selectedDays = 1;

  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Generate an Itinerary Plan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text('How many days?'),
            Row(
              children: [
                Radio<int>(
                  value: 1,
                  groupValue: selectedDays,
                  onChanged: (value) {
                    setState(() {
                      selectedDays = value!;
                    });
                  },
                ),
                Text('1'),
                Radio<int>(
                  value: 2,
                  groupValue: selectedDays,
                  onChanged: (value) {
                    setState(() {
                      selectedDays = value!;
                    });
                  },
                ),
                Text('2'),
                Radio<int>(
                  value: 3,
                  groupValue: selectedDays,
                  onChanged: (value) {
                    setState(() {
                      selectedDays = value!;
                    });
                  },
                ),
                Text('3'),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PackagesScreen(
                      numberOfDays: selectedDays,
                      match: match,
                    ),
                  ),
                );
              },
              child: Text('Generate'),
            ),
          ],
        ),
      );
    },
  );
}

class _Message extends StatelessWidget {
  const _Message({
    Key? key,
    required this.message,
    required this.messageId,
    required this.match,
    this.itinerary,
    this.isAccepted,
    required this.isFromCurrentUser,
  }) : super(key: key);

  final String message;
  final String messageId;
  final Match match;
  final bool isFromCurrentUser;
  final Map<String, dynamic>? itinerary;
  final int? isAccepted;

  @override
  Widget build(BuildContext context) {
    AlignmentGeometry alignment =
        isFromCurrentUser ? Alignment.topRight : Alignment.topLeft;

    Color color = isFromCurrentUser
        ? Theme.of(context).backgroundColor
        : Theme.of(context).primaryColor;

    TextStyle? textStyle = isFromCurrentUser
        ? Theme.of(context).textTheme.headline6!.copyWith(color: Colors.black)
        : Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white);

    if (itinerary != null) {
      return GestureDetector(
        onTap: () {
          if (isFromCurrentUser || isAccepted == 1) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(itinerary?['name']),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var place in itinerary?['places'])
                        ListTile(
                          title: Text(place['name']),
                          subtitle: Text(place['departureTime']),
                        ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else
            () {
              SizedBox();
            };
        },
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.1,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: color,
                ),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            !isFromCurrentUser && isAccepted == null
                ? Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.greenAccent,
                          child: IconButton(
                            onPressed: () {
                              String newId = Uuid().v4();
                              context.read<ChatBloc>().add(
                                    UpdateMessage(
                                      userId: match.matchUser.id!,
                                      matchUserId: match.userId,
                                      itinerary: itinerary,
                                      isAccepted: 1,
                                      message: 'View Details',
                                      messageId: newId,
                                      oldMessageId: messageId,
                                    ),
                                  );
                              print("THIS IS THE MESSAGE ID ===> " + messageId);
                              print("THIS IS THE NEW ID ===>" + newId);
                            },
                            icon: Icon(Icons.check),
                          ),
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.redAccent,
                          child: IconButton(
                            onPressed: () {
                              String newId = Uuid().v4();
                              context.read<ChatBloc>().add(
                                    UpdateMessage(
                                      userId: match.matchUser.id!,
                                      matchUserId: match.userId,
                                      itinerary: itinerary,
                                      isAccepted: 0,
                                      message: 'Invitation Closed.',
                                      messageId: newId,
                                      oldMessageId: messageId,
                                    ),
                                  );
                              print("THIS IS THE MESSAGE ID ===> " + messageId);
                              print("THIS IS THE NEW ID ===>" + newId);
                            },
                            icon: Icon(Icons.close),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
          ],
        ),
      );
    } else {
      if (!isFromCurrentUser) {
        return Container(
          child: Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(match.matchUser.imageUrls[0]),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                  child: Align(
                    alignment: alignment,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: color,
                      ),
                      child: Text(
                        message,
                        style: textStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Align(
          alignment: alignment,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: color,
            ),
            child: Text(
              message,
              style: textStyle,
            ),
          ),
        );
      }
    }
  }
}
