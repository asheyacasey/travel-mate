import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Message extends Equatable {
  final String senderId;
  final String receiverId;
  final String messageId;
  final String message;
  final int? numberOfDays;
  final int? itineraryAccept;
  final Map<String, dynamic>? itinerary;
  final double? placeLat;
  final double? placeLon;
  final double? placeRadius;
  final DateTime dateTime;
  final String timeString;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.messageId,
    required this.message,
    this.numberOfDays,
    this.itinerary,
    this.itineraryAccept,
    this.placeLat,
    this.placeLon,
    this.placeRadius,
    required this.dateTime,
    required this.timeString,
  });

  factory Message.fromJson(Map<String, dynamic> json, {String? id}) {
    return Message(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      messageId: json['messageId'],
      message: json['message'],
      numberOfDays: json['numberOfDays'],
      itinerary: json['itinerary'],
      itineraryAccept: json['itineraryAccept'],
      placeLat: json['placeLat'],
      placeLon: json['placeLon'],
      placeRadius: json['placeRadius'],
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
      'messageId': messageId,
      'message': message,
      'numberOfDays': numberOfDays,
      'itinerary': itinerary,
      'itineraryAccept': itineraryAccept,
      'placeLat': placeLat,
      'placeLon': placeLon,
      'placeRadius': placeRadius,
      'dateTime': dateTime,
    };
  }

  @override
  List<Object?> get props => [
        senderId,
        receiverId,
        messageId,
        message,
        numberOfDays,
        itinerary,
        itineraryAccept,
        placeLat,
        placeLon,
        placeRadius,
        dateTime,
        timeString,
      ];

  // static List<Message> messages = [
  //   Message(
  //     senderId: '1',
  //     receiverId: '2',
  //     message: 'Hey, how are you doing?',
  //     dateTime: DateTime.now(),
  //     timeString: DateFormat('jm').format(
  //       DateTime.now(),
  //     ),
  //   )
  // ];
}
