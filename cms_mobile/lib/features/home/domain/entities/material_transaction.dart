import 'package:equatable/equatable.dart';

class MaterialTransactionEntity extends Equatable {
  final String? type;
  final int? pendingCount;
  final int? approvedCount;
  final int? declinedCount;


  const MaterialTransactionEntity({
    this.type,
    this.pendingCount,
    this.approvedCount,
    this.declinedCount,
  });

  @override
  List<Object?> get props {
    return [
      type,
      pendingCount,
      approvedCount,
      declinedCount,
    ];
  }
}
