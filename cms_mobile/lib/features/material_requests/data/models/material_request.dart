import 'package:cms_mobile/features/material_requests/domain/entities/material_request.dart';

class MaterialRequestModel extends MaterialRequestEntity {
  const MaterialRequestModel({
    required String id,
  }) : super(id: id);

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }

  factory MaterialRequestModel.fromJson(Map<String, dynamic> json) {
    return MaterialRequestModel(
      id: json['id'],
      // created_at: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}
