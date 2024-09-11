import 'package:cms_mobile/features/home/domain/entities/dashboard.dart';

class DashboardModel extends DashboardEntity {
  const DashboardModel({
    required DurationEntity duration,
    required ExpenditureEntity expenditure,
    required int progress,
  }) : super(
          duration: duration,
          expenditure: expenditure,
          progress: progress,
        );

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      duration: DurationModel.fromJson(json['duration']),
      expenditure: ExpenditureModel.fromJson(json['expenditure']),
      progress: json['progress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duration': (duration as DurationModel).toJson(),
      'expenditure': (expenditure as ExpenditureModel).toJson(),
      'progress': progress,
    };
  }
}

class DurationModel extends DurationEntity {
  const DurationModel({
    required super.days,
    required super.hours,
    required super.minutes,
    required super.seconds,
  });

  factory DurationModel.fromJson(Map<String, dynamic> json) {
    return DurationModel(
      days: json['days'],
      hours: json['hours'],
      minutes: json['minutes'],
      seconds: json['seconds'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'days': days,
      'hours': hours,
      'minutes': minutes,
      'seconds': seconds,
    };
  }
}

class ExpenditureModel extends ExpenditureEntity {
  const ExpenditureModel({
    required super.totalExpenditure,
    required super.totalItemCost,
    required super.totalLaborCost,
    required super.totalTransportationCost,
  });

  factory ExpenditureModel.fromJson(Map<String, dynamic> json) {
    return ExpenditureModel(
      totalExpenditure: (json['totalExpenditure'] as num).toDouble(),
      totalItemCost: (json['totalItemCost'] as num).toDouble(),
      totalLaborCost: (json['totalLaborCost'] as num).toDouble(),
      totalTransportationCost:
          (json['totalTransportationCost'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalExpenditure': totalExpenditure,
      'totalItemCost': totalItemCost,
      'totalLaborCost': totalLaborCost,
      'totalTransportationCost': totalTransportationCost,
    };
  }
}
