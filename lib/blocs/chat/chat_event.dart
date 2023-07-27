part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChat extends ChatEvent {
  final String? chatId;

  const LoadChat(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class UpdateChat extends ChatEvent {
  final Chat chat;

  UpdateChat({required this.chat});

  @override
  List<Object?> get props => [chat];
}

class AddMessage extends ChatEvent {
  final String userId;
  final String matchUserId;
  final String message;
  final String messageId;
  final Map<String, dynamic>? itinerary;
  final int? index;

  AddMessage(
      {required this.userId,
      required this.matchUserId,
      required this.message,
      required this.messageId,
      this.itinerary,
      this.index});

  @override
  List<Object?> get props =>
      [userId, matchUserId, message, messageId, itinerary, index];
}

class UpdateMessage extends ChatEvent {
  final String userId;
  final String matchUserId;
  final String message;
  final String messageId;
  final String oldMessageId;
  final Map<String, dynamic>? itinerary;
  final double? placeLat;
  final double? placeLon;
  final double? placeRadius;
  final int? isAccepted;
  final int? numberOfDays;

  UpdateMessage(
      {required this.userId,
      required this.matchUserId,
      required this.message,
      required this.messageId,
      required this.oldMessageId,
      this.itinerary,
      this.placeLat,
      this.placeLon,
      this.placeRadius,
      this.numberOfDays,
      this.isAccepted});

  @override
  List<Object?> get props => [
        userId,
        matchUserId,
        message,
        messageId,
        oldMessageId,
        numberOfDays,
        placeLat,
        placeLon,
        placeRadius,
        itinerary,
        isAccepted
      ];
}

class DeleteMessage extends ChatEvent {
  final String userId;
  final String matchUserId;
  final String message;
  final String messageId;
  final int? isAccepted;

  DeleteMessage(
      {required this.userId,
      required this.matchUserId,
      required this.message,
      required this.messageId,
      this.isAccepted});

  @override
  List<Object?> get props =>
      [userId, matchUserId, message, messageId, isAccepted];
}
