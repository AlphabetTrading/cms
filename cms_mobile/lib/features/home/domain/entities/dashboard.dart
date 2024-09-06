import 'package:equatable/equatable.dart';

class DashboardEntity extends Equatable {
  final DurationEntity duration;
  final ExpenditureEntity expenditure;
  final int progress;

  const DashboardEntity({
    required this.duration,
    required this.expenditure,
    required this.progress,
  });

  @override
  List<Object?> get props => [duration, expenditure, progress];
}

class DurationEntity extends Equatable {
  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  const DurationEntity({
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  @override
  List<Object?> get props => [days, hours, minutes, seconds];
}

class ExpenditureEntity extends Equatable {
  final double totalExpenditure;
  final double totalItemCost;
  final double totalLaborCost;
  final double totalTransportationCost;

  const ExpenditureEntity({
    required this.totalExpenditure,
    required this.totalItemCost,
    required this.totalLaborCost,
    required this.totalTransportationCost,
  });

  @override
  List<Object?> get props => [
        totalExpenditure,
        totalItemCost,
        totalLaborCost,
        totalTransportationCost
      ];
}
