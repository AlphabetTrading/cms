// import 'package:cms_mobile/features/progress/domain/entities/milestone.dart';
// import 'package:cms_mobile/features/progress/domain/usecases/get_milestones.dart';
// import 'package:equatable/equatable.dart';
// import 'package:cms_mobile/core/resources/data_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// abstract class UsersState extends Equatable {
//   const UsersState();

//   @override
//   List<Object> get props => [];
// }

// class UsersInitial extends UsersState {}

// class UsersLoading extends UsersState {}

// class UsersSuccess extends UsersState {
//   final MilestoneEntityListWithMeta? milestoneEntityListWithMeta;

//   const UsersSuccess({this.milestoneEntityListWithMeta});

//   @override
//   List<Object> get props => [milestoneEntityListWithMeta!];
// }

// class UsersFailed extends UsersState {
//   final String error;

//   const UsersFailed({required this.error});

//   @override
//   List<Object> get props => [error];
// }

// abstract class UsersEvent {}

// class GetUsersEvent extends UsersEvent {
//   final GetUsersParamsEntity getUsersParamsEntity;

//   GetUsersEvent({required this.getUsersParamsEntity});
// }

// class UsersCubit extends Cubit<UsersState> {
//   final GetUsersUseCase _getUsersUseCase;

//   UsersCubit(this._getUsersUseCase)
//       : super(UsersInitial());

//   void onGetUsers({required  GetUsersParamsEntity getUsersParamsEntity}) async {
//     emit(UsersLoading());
//     final dataState =
//         await _getUsersUseCase(params: getUsersParamsEntity);
//     if (dataState is DataSuccess) {
//       emit(UsersSuccess(
//           milestoneEntityListWithMeta: dataState.data as MilestoneEntityListWithMeta));
//     } else if (dataState is DataFailed) {
//       emit(UsersFailed(
//           error: dataState.error?.errorMessage ??
//               'Failed to get milestones'));
//     }
//   }
// }
