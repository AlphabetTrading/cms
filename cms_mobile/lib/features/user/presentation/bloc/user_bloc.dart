import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/user/domain/usecases/get_users_usecase.dart';
import 'package:cms_mobile/features/user/presentation/bloc/user_event.dart';
import 'package:cms_mobile/features/user/presentation/bloc/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

const throttleDuration = Duration(seconds: 1);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUseCase _getUsersUseCase;

  UserBloc(this._getUsersUseCase) : super(const UserInitial()) {
    on<GetUsers>(onGetUsers);
  }

  void onGetUsers(GetUsers event, Emitter<UserState> emit) async {
    emit(const UsersLoading());

    final dataState = await _getUsersUseCase(
        params: UserParams(filterUserInput: event.filterUserInput));

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(UsersSuccess(users: dataState.data!));
    }
    if (dataState is DataFailed) {
      emit(UsersFailed(error: dataState.error!));
    }
  }
}
