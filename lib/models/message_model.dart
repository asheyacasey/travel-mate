import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Message extends Equatable {
  final String senderId;
  final String receiverId;
  final String message;
  final String? itinerary;
  final DateTime dateTime;
  final String timeString;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.itinerary,
    required this.dateTime,
    required this.timeString,
  });

  factory Message.fromJson(Map<String, dynamic> json, {String? id}) {
    return Message(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
      itinerary: json['itinerary'],
      dateTime: (json['dateTime'] as Timestamp).toDate(),
      timeString: DateFormat('HH:mm').format(
        json['dateTime'].toDate(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'itinerary': itinerary,
      'dateTime': dateTime,
    };
  }

  @override
  List<Object?> get props => [
        senderId,
        receiverId,
        message,
        itinerary,
        dateTime,
        timeString,
      ];

  static List<Message> messages = [
    Message(
      senderId: '1',
      receiverId: '2',
      message: 'Hey, how are you doing?',
      dateTime: DateTime.now(),
      timeString: DateFormat('jm').format(
        DateTime.now(),
      ),
    )
  ];
}
