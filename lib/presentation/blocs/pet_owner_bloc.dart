import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/pet_owner.dart';
import '../../data/repositories/pet_owner_repository_impl.dart';

// Events
abstract class PetOwnerEvent {}
class LoadPetOwners extends PetOwnerEvent {}
class AddPetOwner extends PetOwnerEvent {
  final PetOwner owner;
  AddPetOwner(this.owner);
}
class UpdatePetOwner extends PetOwnerEvent {
  final int id;
  final PetOwner owner;
  UpdatePetOwner(this.id, this.owner);
}
class DeletePetOwner extends PetOwnerEvent {
  final int id;
  DeletePetOwner(this.id);
}

// States
abstract class PetOwnerState {}
class PetOwnerInitial extends PetOwnerState {}
class PetOwnerLoading extends PetOwnerState {}
class PetOwnerLoaded extends PetOwnerState {
  final List<PetOwner> owners;
  PetOwnerLoaded(this.owners);
}
class PetOwnerError extends PetOwnerState {
  final String message;
  PetOwnerError(this.message);
}

// Bloc
class PetOwnerBloc extends Bloc<PetOwnerEvent, PetOwnerState> {
  final PetOwnerRepositoryImpl repository;
  PetOwnerBloc(this.repository) : super(PetOwnerInitial()) {
    on<LoadPetOwners>((event, emit) async {
      emit(PetOwnerLoading());
      try {
        final owners = await repository.getAll();
        emit(PetOwnerLoaded(owners));
      } catch (e) {
        emit(PetOwnerError(e.toString()));
      }
    });
    on<AddPetOwner>((event, emit) async {
      try {
        await repository.create(event.owner);
        add(LoadPetOwners());
      } catch (e) {
        emit(PetOwnerError(e.toString()));
      }
    });
    on<UpdatePetOwner>((event, emit) async {
      try {
        await repository.update(event.id, event.owner);
        add(LoadPetOwners());
      } catch (e) {
        emit(PetOwnerError(e.toString()));
      }
    });
    on<DeletePetOwner>((event, emit) async {
      try {
        await repository.delete(event.id);
        add(LoadPetOwners());
      } catch (e) {
        emit(PetOwnerError(e.toString()));
      }
    });
  }
} 