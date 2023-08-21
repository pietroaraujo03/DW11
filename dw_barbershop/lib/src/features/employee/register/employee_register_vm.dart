import 'package:asyncstate/asyncstate.dart';
import 'package:dw_barbershop/src/core/fp/either.dart';
import 'package:dw_barbershop/src/core/fp/nil.dart';
import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/exceptions/repository_exception.dart';
import 'package:dw_barbershop/src/features/employee/register/employee_register_state.dart';
import 'package:dw_barbershop/src/model/barbershop_model.dart';
import 'package:dw_barbershop/src/repositories/user/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';



part 'employee_register_vm.g.dart';

@riverpod
class EmployeeRegisterVm extends _$EmployeeRegisterVm {

  @override
  EmployeeRegisterState build() => EmployeeRegisterState.initial();
  
  void setRegisterADM(bool isRegisterADM) {
    state = state.copyWith(resgisterADM: isRegisterADM);
  }

  void addOrRemoveWorkDays(String weekDay) {
    final EmployeeRegisterState(:workdays) = state;

    if(workdays.contains(weekDay)){
      workdays.remove(weekDay);
    }else{
      workdays.add(weekDay);
    }

    state = state.copyWith(workdays: workdays);
  }
  void addOrRemoveWorkHours(int hour) {
    final EmployeeRegisterState(:workhours) = state;

    if(workhours.contains(hour)){
      workhours.remove(hour);
    }else{
      workhours.add(hour);
    }

    state = state.copyWith(workhours: workhours);
  }

  Future<void> register({String? name, String? email, String? password}) async {

    final EmployeeRegisterState(:resgisterADM, :workdays, :workhours) = state;
    final asyncLoaderHandler = AsyncLoaderHandler()..start();

    final UserRepository(:registerAdmAsEmployee, :registerEmployee) =
        ref.read(userRepositoryProvider);

    final Either<RepositoryException, Nil> resultRegister;


    if(resgisterADM){
      final dto = (
        workdays: workdays,
        workHours: workhours
      );

      resultRegister = await registerAdmAsEmployee(dto);
    }else{
      final BarbershopModel(:id) = await ref.watch(getMyBarbershopProvider.future);
      final dto = (
        barbershopId: id,
        name: name!,
        email: email!,
        password: password!,
        workdays: workdays,
        workHours: workhours,
      );

      resultRegister = await registerEmployee(dto);
    }

    switch(resultRegister){
      case Success():
          state = state.copyWith(status: EmployeeRegisterStateStatus.success);
      case Failure():
          state = state.copyWith(status: EmployeeRegisterStateStatus.error);
    }
    asyncLoaderHandler.close();
  }

}