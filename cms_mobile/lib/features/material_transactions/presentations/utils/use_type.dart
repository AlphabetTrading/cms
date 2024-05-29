import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';

Map<UseType, String> useTypeDisplay = {
  UseType.SUB_STRUCTURE: "Sub-Structure",
  UseType.SUPER_STRUCTURE: "Super-Structure",
};

Map<SubStructureUseDescription, String> subStructureUseDescriptionDisplay = {
  SubStructureUseDescription.EXCAVATION_AND_EARTH_WORK:
      "Excavation and Earth Work",
  SubStructureUseDescription.CONCRETE_WORK: "Concrete Work",
  SubStructureUseDescription.MASONRY_WORK: "Masonry Work",
  SubStructureUseDescription.DEFAULT_VALUE: "",
};

Map<SuperStructureUseDescription, String> superStructureUseDescriptionDisplay =
    {
  SuperStructureUseDescription.CONCRETE_WORK: "Concrete Work",
  SuperStructureUseDescription.BLOCK_WORK: "Block Work",
  SuperStructureUseDescription.ROOFING: "Roofing",
  SuperStructureUseDescription.CARPENTRY_AND_JOINERY: "Carpentry and Joinery",
  SuperStructureUseDescription.METAL_WORK: "Metal Work",
  SuperStructureUseDescription.PLASTERING_WORK: "Plastering Work",
  SuperStructureUseDescription.FINISHING_WORK: "Finishing Work",
  SuperStructureUseDescription.PAINTING_WORK: "Painting Work",
  SuperStructureUseDescription.SANITARY_INSTALLATION: "Sanitary Installation",
  SuperStructureUseDescription.ELECTRICAL_INSTALLATION:
      "Electrical Installation",
  SuperStructureUseDescription.MECHANICAL_INSTALLATION:
      "Mechanical Installation",
  SuperStructureUseDescription.DEFAULT_VALUE: "",
};

// Function to convert string to UseType enum
UseType useTypeFromString(String? value) {

  return UseType.values.firstWhere(
    (e) => e.toString().split('.').last == value,
    orElse: () => UseType.DEFAULT_VALUE,
  );
}

// Function to convert string to SubStructureUseDescription enum
SubStructureUseDescription subStructureUseDescriptionFromString(String? value) {

  return SubStructureUseDescription.values.firstWhere(
    (e) => e.toString().split('.').last == value,
    orElse: () => SubStructureUseDescription.DEFAULT_VALUE,
  );
}

// Function to convert string to SuperStructureUseDescription enum
SuperStructureUseDescription superStructureUseDescriptionFromString(
    String? value) {
  return SuperStructureUseDescription.values.firstWhere(
    (e) => e.toString().split('.').last == value,
    orElse: () => SuperStructureUseDescription.DEFAULT_VALUE,
  );
}
