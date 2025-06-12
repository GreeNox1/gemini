part of "message_bloc.dart";

sealed class HomeEvent {
  const HomeEvent();
}

final class SendMessage$HomeEvent extends HomeEvent {
  const SendMessage$HomeEvent({required this.context, required this.text});

  final BuildContext context;
  final String text;
}
