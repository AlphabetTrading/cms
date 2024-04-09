import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/items/domain/entities/item.dart';
import 'package:equatable/equatable.dart';

abstract class ItemState extends Equatable {
  final List<ItemEntity>? items;
  final Failure? error;
  const ItemState({this.items, this.error});

  @override
  List<Object?> get props => [items, error];
}

class ItemInitial extends ItemState {
  const ItemInitial();
}

class ItemsLoading extends ItemState {
  const ItemsLoading();
}

class ItemsSuccess extends ItemState {
  const ItemsSuccess({required List<ItemEntity> items})
      : super(items: items);
}

class ItemsFailed extends ItemState {
  const ItemsFailed({required Failure error})
      : super(error: error);
}
class ItemsEmpty extends ItemState {
  const ItemsEmpty();
}
