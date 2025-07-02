import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/pet_owner_dto.dart';
import '../../domain/repositories/pet_owner_repository.dart';

abstract class PetOwnerState {}
class PetOwnerInitial extends PetOwnerState {}
class PetOwnerLoading extends PetOwnerState {}
class PetOwnerLoaded extends PetOwnerState {
  final PetOwnerDto? petOwner;
  PetOwnerLoaded(this.petOwner);
}
class PetOwnerError extends PetOwnerState {
  final String error;
  PetOwnerError(this.error);
}

class PetOwnerCubit extends Cubit<PetOwnerState> {
  final PetOwnerRepository repository;
  PetOwnerCubit(this.repository) : super(PetOwnerInitial());

  Future<void> getByPetId(int petId) async {
    emit(PetOwnerLoading());
    try {
      final petOwner = await repository.getByPetId(petId);
      emit(PetOwnerLoaded(petOwner));
    } catch (e) {
      emit(PetOwnerError(e.toString()));
    }
  }
} 