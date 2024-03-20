import 'package:equatable/equatable.dart';

class MaterialRequestEntity extends Equatable {
  final String? id;
  

  const MaterialRequestEntity({
    this.id,
  });

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }
}
