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
  final Map<String, dynamic>? itinerary;
  final int? index;

  AddMessage(
      {required this.userId,
      required this.matchUserId,
      required this.message,
      this.itinerary,
      this.index});

  @override
  List<Object?> get props => [userId, matchUserId, message, itinerary, index];
}

class UpdateMessage extends ChatEvent {
  final String userId;
  final String matchUserId;
  final String message;
  final Map<String, dynamic>? itinerary;
  final int? isAccepted;

  UpdateMessage(
      {required this.userId,
      required this.matchUserId,
      required this.message,
      this.itinerary,
      this.isAccepted});

  @override
  List<Object?> get props =>
      [userId, matchUserId, message, itinerary, isAccepted];
}
