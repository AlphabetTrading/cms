import 'package:equatable/equatable.dart';

abstract class DataState<T> {
  final T? data;
  final Failure? error;

  const DataState({this.data, this.error});

  void fold(void Function(dynamic l) param0, void Function(dynamic r) param1) {
    if (data != null) {
      param1(data);
    } else if (error != null) {
      param0(error);
    }
  }
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(Failure error) : super(error: error);
}

abstract class Failure extends Equatable {
  abstract final String errorMessage;
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  @override
  final String errorMessage;
  ServerFailure({this.errorMessage = 'Server failure'});
}

class CacheFailure extends Failure {
  @override
  final String errorMessage;
  CacheFailure({this.errorMessage = 'Cache failure'});
}

class NetworkFailure extends Failure {
  @override
  final String errorMessage;
  NetworkFailure({this.errorMessage = 'No internet connection'});
}

class UnauthorizedRequestFailure extends Failure {
  @override
  final String errorMessage;

  UnauthorizedRequestFailure({this.errorMessage = 'User not authenticated'});
}

class AnonymousFailure extends Failure {
  @override
  final String errorMessage;
  AnonymousFailure({this.errorMessage = 'Unknown error happened'});
}

class UserAlreadyRegisteredFailure extends Failure {
  @override
  final String errorMessage;
  UserAlreadyRegisteredFailure({this.errorMessage = 'User already registered'});
}
