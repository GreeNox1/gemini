part of 'message_bloc.dart';

class HomeState extends Equatable {
  const HomeState({this.messages = const [], this.status = Status.initial});

  final List<MessageModel> messages;
  final Status status;

  HomeState copyWith({List<MessageModel>? messages, Status? status}) {
    return HomeState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [messages];
}
