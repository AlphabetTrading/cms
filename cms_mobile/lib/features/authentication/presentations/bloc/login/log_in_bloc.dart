import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'log_in_event.dart';
part 'log_in_state.dart';

class LoginBloc extends Bloc<LoginFormEvent, LoginFormState> {
  LogInUseCase logInUseCase;
  LoginBloc(this.logInUseCase) : super(LoginInitial()) {
    on<LoginEvent>(_onLogin);
  }

  void _onLogin(LoginEvent event, Emitter<LoginFormState> emit) async {
    emit(LoginLoading());

    final response = await logInUseCase(
      LoginParams(
        password: event.loginParams.password,
        phoneNumber: event.loginParams.phoneNumber,
      ),
    );

    response.fold((l) => emit(LoginFailed(errorMessage: l.errorMessage)), (r) => emit(LoginSuccess()));
  }
}
