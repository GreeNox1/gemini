import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:udevs/src/common/model/message_model.dart';

import '../../../common/utils/enums/status.dart';
import '../data/home_repository.dart';

part 'message_event.dart';
part 'message_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required final IHomeRepository homeRepository})
    : _homeRepository = homeRepository,
      super(const HomeState()) {
    on<HomeEvent>(
      (event, emit) => switch (event) {
        SendMessage$HomeEvent _ => _sendMessage(event, emit),
      },
    );
  }

  final IHomeRepository _homeRepository;

  Future<void> _sendMessage(
    SendMessage$HomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    try {
      emit(state.copyWith(status: Status.success));
    } on Object catch (_) {
      emit(state.copyWith(status: Status.error));
    }
  }
}
