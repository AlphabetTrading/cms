// import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
// import 'package:cms_mobile/features/home/domain/entities/project.dart';
// import 'package:cms_mobile/features/progress/data/models/milestone.dart';

// class ProjectModel extends ProjectEntity {
//   const ProjectModel({
//     required String id,
//     required String name,
//     required DateTime startDate,
//     required DateTime endDate,
//     required double budget,
//     required String clientId,
//     required String projectManagerId,
//     required String status,
//     required DateTime createdAt,
//     required DateTime updatedAt,
//     required List<MilestoneModel> milestones,
//     required UserEntity projectManager,
//     required UserEntity client,
//   }) : super(
//           id: id,
//           name: name,
//           startDate: startDate,
//           endDate: endDate,
//           budget: budget,
//           clientId: clientId,
//           projectManagerId: projectManagerId,
//           status: status,
//           createdAt: createdAt,
//           updatedAt: updatedAt,
//           milestones: milestones,
//           projectManager: projectManager,
//           client: client,
//         );


//   factory ProjectModel.fromJson(Map<String, dynamic> json) {
//     return ProjectModel(
//       id: json['id'],
//       name: json['name'],
//       startDate: json['startDate'],
//       endDate: json['endDate'],
//       budget: json['budget'],
//       clientId: json['clientId'],
//       projectManagerId: json['projectManagerId'],
//       status: json['status'],
//       createdAt: json['createdAt'],
//       updatedAt: json['updatedAt'],
//       milestones: json['milestones'],
//       projectManager: json['projectManager'],
//       client: json['client'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'startDate': startDate,
//       'endDate': endDate,
//       'budget': budget,
//       'clientId': clientId,
//       'projectManagerId': projectManagerId,
//       'status': status,
//       'createdAt': createdAt,
//       'updatedAt': updatedAt,
//       'milestones': milestones,
//     };
//   }
// }
