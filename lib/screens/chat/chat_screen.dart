import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_mate/blocs/auth/auth_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:travel_mate/blocs/blocs.dart';
import 'package:travel_mate/repositories/database/database_repository.dart';
import 'package:travel_mate/screens/chat/itinerary_screen.dart';
import 'package:travel_mate/screens/chat/packages_screen.dart';
import 'package:unicons/unicons.dart';
import 'package:travel_mate/models/models.dart';
import 'package:uuid/uuid.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class ChatScreen extends StatelessWidget {
  static const String routeName = '/chat';

  static Route route({required Match match}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: context.read<AuthBloc>()),
          BlocProvider<ChatBloc>(
            create: (context) => ChatBloc(
              databaseRepository: context.read<DatabaseRepository>(),
            )..add(LoadChat(match.chat.id)),
          ),
        ],
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
                          numberOfDays: messages[index].numberOfDays,
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
            radius: 20,
            backgroundImage: NetworkImage(match.matchUser.imageUrls[0]),
          ),
          Text(
            match.matchUser.name,
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(65.0);
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
            IconButton(
              icon: Icon(
                EvaIcons.fileAdd,
                size: 40,
                color: Color(0xFFF5C518),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Center(
                      child: _buildGenerateModal(context, match),
                    );
                  },
                );
              },
            ),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFEDEDED),
                  hintText: 'Type a message',
                  contentPadding:
                      const EdgeInsets.only(left: 20, bottom: 5, top: 5),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
            // IconButton(

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
                child: IconButton(
                  icon: Icon(
                    UniconsLine.message,
                    size: 25,
                  ),
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
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildGenerateModal(BuildContext context, Match match) {
  int selectedDays = 1;
  final TextEditingController _addressController = TextEditingController();
  List<String> _addressSuggestions = [];
  bool isAddressEmpty = false;

  Future<List<String>> _getAddressSuggestions(String query) async {
    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search?format=json&q=$query, Cebu, Philippines');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        final suggestions =
            data.map((item) => item['display_name'] as String).toList();
        return suggestions;
      } else {
        throw Exception(
            'Failed to load address suggestions. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load address suggestions: $e');
    }
  }

  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white
              .withOpacity(0.9), // Add transparency to the white background
          borderRadius: BorderRadius.circular(20.0),
        ),
        height: MediaQuery.of(context).size.height * 0.6,
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'travelmate',
                style: GoogleFonts.fredokaOne(
                  textStyle: TextStyle(
                    fontSize: 25,
                    color: Color(0xFFB0DB2D),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Color(0xFFF5C518),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    'Itinerary Planner',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.transparent,
                  border: Border.all(
                    color: Color(
                        0xFFECEAEA), // Replace with your desired border color
                    width: 2.0, // Adjust the border width as needed
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 15.0),
                  child: Column(
                    children: [
                      Text(
                        'How many days do you plan to travel together?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 180,
                              child: TextButton(
                                onPressed: () =>
                                    setState(() => selectedDays = 1),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    selectedDays == 1
                                        ? Color(0xFFF5C518)
                                        : Color(0xFFEDEDED),
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  '1 Day',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: selectedDays == 1
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 180,
                              child: TextButton(
                                onPressed: () =>
                                    setState(() => selectedDays = 2),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    selectedDays == 2
                                        ? Color(0xFFF5C518)
                                        : Color(0xFFEDEDED),
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  '2 Days',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: selectedDays == 2
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 180,
                              child: TextButton(
                                onPressed: () =>
                                    setState(() => selectedDays = 3),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    selectedDays == 3
                                        ? Color(0xFFF5C518)
                                        : Color(0xFFEDEDED),
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  '3 Days or more',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: selectedDays == 3
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Enter a place',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Material(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        hintText: 'Enter a place',
                      ),
                      onChanged: (query) {
                        _getAddressSuggestions(query).then((suggestions) {
                          // Show the suggestions to the user (e.g., using a ListView)
                          print(suggestions);
                          setState(() {
                            _addressSuggestions = suggestions;
                          });
                        }).catchError((error) {
                          print('Failed to load address suggestions: $error');
                        });
                      },
                    ),
                    if (isAddressEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Please enter a place.',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    SizedBox(height: 10),
                    if (_addressSuggestions.isNotEmpty)
                      Container(
                        height: 200,
                        child: ListView.builder(
                          itemCount: _addressSuggestions.length,
                          itemBuilder: (context, index) {
                            final suggestion = _addressSuggestions[index];
                            return ListTile(
                              title: Text(suggestion),
                              onTap: () {
                                setState(() {
                                  _addressController.text = suggestion;
                                  _addressSuggestions = [];
                                  isAddressEmpty = false;
                                });
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                height: 50, // Adjust the height as desired
                width: 300, // Adjust the width as desired
                child: TextButton(
                  onPressed: () async {
                    if (_addressController.text.isEmpty) {
                      setState(() => isAddressEmpty = true);
                    } else {
                      final url = Uri.parse(
                          'https://nominatim.openstreetmap.org/search?format=json&q=${_addressController.text}');
                      final response = await http.get(url);

                      if (response.statusCode == 200) {
                        final data = jsonDecode(response.body) as List<dynamic>;
                        if (data.isNotEmpty) {
                          final lat = double.parse(data[0]['lat']);
                          final lon = double.parse(data[0]['lon']);

                          // Navigate to the PackagesScreen if the address is not empty
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PackagesScreen(
                                numberOfDays: selectedDays,
                                match: match,
                                lat: lat,
                                lon: lon,
                              ),
                            ),
                          );
                        }
                      } else {
                        print('Failed to fetch coordinates for the address');
                      }
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFFB0DB2D)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'Create Itinerary Plan',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
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
    this.numberOfDays,
    required this.isFromCurrentUser,
  }) : super(key: key);

  final String message;
  final String messageId;
  final Match match;
  final bool isFromCurrentUser;
  final Map<String, dynamic>? itinerary;
  final int? isAccepted;
  final int? numberOfDays;

  @override
  Widget build(BuildContext context) {
    final List<dynamic> activitiesData = itinerary?['activities'] ?? [];

    // Convert activitiesData into List<Activity>
    final List<Activity> activities = activitiesData.map((data) {
      return Activity.fromFirebaseMap(data, context);
    }).toList();

    TimeOfDay calculateTimeEnd(TimeOfDay startTime, int duration) {
      int startMinutes = startTime.hour * 60 + startTime.minute;
      int endMinutes = startMinutes + duration;

      int endHour = endMinutes ~/ 60;
      int endMinute = endMinutes % 60;

      return TimeOfDay(hour: endHour, minute: endMinute);
    }

    List<List<Activity>> groupByDay(List<Activity> activities) {
      List<List<Activity>> activitiesByDay = [];
      List<Activity> currentDayActivities = [];

      DateTime currentDay = DateTime.now();
      TimeOfDay nextActivityStart = TimeOfDay(hour: 7, minute: 0);
      int totalDuration = 0;

      for (int i = 0; i < activities.length; i++) {
        Activity activity = activities[i];
        DateTime activityDateTime = DateTime(
          currentDay.year,
          currentDay.month,
          currentDay.day,
          activity.timeStart.hour,
          activity.timeStart.minute,
        );

        int activityDuration = activity.duration;

        if (totalDuration + activityDuration > 600 ||
            activityDateTime.difference(currentDay).inDays > 0) {
          // Check if new day is being set, update nextActivityStart to 7:00 AM
          nextActivityStart = TimeOfDay(hour: 7, minute: 0);

          activitiesByDay.add(currentDayActivities);
          currentDayActivities = [];
          totalDuration = 0;
        }

        // Set timeStart of activity to nextActivityStart
        activity.timeStart = nextActivityStart;

        // Calculate and set timeEnd based on timeStart and duration
        activity.timeEnd =
            calculateTimeEnd(activity.timeStart, activity.duration);

        currentDayActivities.add(activity);
        totalDuration += activityDuration;

        // Update nextActivityStart for the next iteration
        nextActivityStart = activity.timeEnd;
        currentDay = activityDateTime;
      }

      if (currentDayActivities.isNotEmpty) {
        activitiesByDay.add(currentDayActivities);
      }

      return activitiesByDay;
    }

    final List<List<Activity>> activitiesByDay = groupByDay(activities);

    AlignmentGeometry alignment =
        isFromCurrentUser ? Alignment.topRight : Alignment.topLeft;

    Color color = isFromCurrentUser
        ? Theme.of(context).primaryColor
        : Theme.of(context).backgroundColor;

    TextStyle? textStyle = isFromCurrentUser
        ? Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Colors.white, fontSize: 17)
        : Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Colors.black, fontSize: 17);

    if (itinerary != null) {
      return GestureDetector(
        onTap: () {
          if (isFromCurrentUser || isAccepted == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItineraryScreen(
                    itinerary: itinerary,
                    numberOfDays: numberOfDays,
                    match: match,
                    oldMessageId: messageId),
              ),
            );
          } else if (!isFromCurrentUser && isAccepted == null) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Itinerary Preview'),
                content: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: ListView.builder(
                    itemCount: activitiesByDay.length,
                    itemBuilder: (context, dayIndex) {
                      final List<Activity> dayActivities =
                          activitiesByDay[dayIndex];
                      final int dayNumber = dayIndex + 1;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Day $dayNumber',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: dayActivities.length,
                            itemBuilder: (context, index) {
                              final Activity activity = dayActivities[index];

                              return ListTile(
                                title: Text(activity.activityName),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Category: ${activity.category}'),
                                    Text('Address: ${activity.address}'),
                                    Text('Duration: ${activity.duration} mins'),
                                    Text(
                                        'Time Start: ${activity.timeStart.format(context)}'),
                                    Text(
                                        'Time End: ${activity.timeEnd.format(context)}'),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          }
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
                        Container(
                          width:
                              45, // Set a width for the container to provide enough space for the CircleAvatar
                          height:
                              45, // Set a height for the container to make it a square (for circular appearance)
                          decoration: BoxDecoration(
                            shape: BoxShape
                                .circle, // Set the container shape to circle
                            color: Color(
                                0xFFB8ED19), // Set your desired circle background color (green)
                          ),
                          child: IconButton(
                            onPressed: () {
                              String newId = Uuid().v4();
                              context.read<ChatBloc>().add(
                                    UpdateMessage(
                                      userId: match.matchUser.id,
                                      matchUserId: match.userId,
                                      itinerary: itinerary,
                                      numberOfDays: numberOfDays,
                                      isAccepted: 1,
                                      message:
                                          '${context.read<AuthBloc>().state.user!.name} accepted the invitation',
                                      messageId: newId,
                                      oldMessageId: messageId,
                                    ),
                                  );
                              print("THIS IS THE MESSAGE ID ===> " + messageId);
                              print("THIS IS THE NEW ID ===>" + newId);
                            },
                            icon: Center(
                              child: Icon(
                                UniconsLine
                                    .check, // Unicons "check-circle" icon (monochrome version)
                                color: Colors
                                    .white, // Set your desired monochrome icon color
                                size: 30, // Set your desired icon size
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            shape: BoxShape
                                .circle, // Set the container shape to circle
                            color: Color(0xFFDCDCDC),
                          ),
                          child: IconButton(
                            onPressed: () {
                              String newId = Uuid().v4();
                              context.read<ChatBloc>().add(
                                    UpdateMessage(
                                      userId: match.matchUser.id,
                                      matchUserId: match.userId,
                                      itinerary: itinerary,
                                      isAccepted: 0,
                                      message:
                                          '${context.read<AuthBloc>().state.user!.name} denied the invitation.',
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
                radius: 22,
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
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
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
