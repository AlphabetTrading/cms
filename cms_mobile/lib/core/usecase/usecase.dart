// abstract class UseCase<Type,Params> {
//   Future<Type> call({Params params});
// }


import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:equatable/equatable.dart';
 
abstract class UseCase<Type, Params> {
  Future<DataState<Type>> call({Params params});
}

abstract class UseCaseWithoutState<Type, Params> {
  Future<Type> call({Params params});
}

abstract class Params extends Equatable {}

class NoParams extends Params {
  @override
  List<Object?> get props => [];
}
