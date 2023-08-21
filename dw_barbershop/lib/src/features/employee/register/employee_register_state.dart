enum EmployeeRegisterStateStatus { initial, success, error }

class EmployeeRegisterState {
  final EmployeeRegisterStateStatus status;
  final bool resgisterADM;
  final List<String> workdays;
  final List<int> workhours;

  EmployeeRegisterState.initial()
      : this(
          status: EmployeeRegisterStateStatus.initial,
          resgisterADM: false,
          workdays: <String>[],
          workhours: <int>[],
        );

  EmployeeRegisterState({
    required this.status,
    required this.resgisterADM,
    required this.workdays,
    required this.workhours,
  });

  EmployeeRegisterState copyWith({
    EmployeeRegisterStateStatus? status,
    bool? resgisterADM,
    List<String>? workdays,
    List<int>? workhours,
  }) {
    return EmployeeRegisterState(
      status: status ?? this.status,
      resgisterADM: resgisterADM ?? this.resgisterADM,
      workdays: workdays ?? this.workdays,
      workhours: workhours ?? this.workhours,
    );
  }
}
