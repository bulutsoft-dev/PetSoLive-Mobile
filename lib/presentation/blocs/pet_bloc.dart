import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/pet.dart';
import '../../data/repositories/pet_repository_impl.dart';

// Events
abstract class PetEvent {}
class LoadPets extends PetEvent {}
class AddPet extends PetEvent {
  final Pet pet;
  AddPet(this.pet);
}
class UpdatePet extends PetEvent {
  final int id;
  final Pet pet;
  UpdatePet(this.id, this.pet);
}
class DeletePet extends PetEvent {
  final int id;
  DeletePet(this.id);
}

// States
abstract class PetState {}
class PetInitial extends PetState {}
class PetLoading extends PetState {}
class PetLoaded extends PetState {
  final List<Pet> pets;
  PetLoaded(this.pets);
}
class PetError extends PetState {
  final String message;
  PetError(this.message);
}

// Bloc
class PetBloc extends Bloc<PetEvent, PetState> {
  final PetRepositoryImpl repository;
  PetBloc(this.repository) : super(PetInitial()) {
    on<LoadPets>((event, emit) async {
      emit(PetLoading());
      try {
        final pets = await repository.getAll();
        emit(PetLoaded(pets));
      } catch (e) {
        emit(PetError(e.toString()));
      }
    });
    on<AddPet>((event, emit) async {
      try {
        await repository.create(event.pet);
        add(LoadPets());
      } catch (e) {
        emit(PetError(e.toString()));
      }
    });
    on<UpdatePet>((event, emit) async {
      try {
        await repository.update(event.id, event.pet);
        add(LoadPets());
      } catch (e) {
        emit(PetError(e.toString()));
      }
    });
    on<DeletePet>((event, emit) async {
      try {
        await repository.delete(event.id);
        add(LoadPets());
      } catch (e) {
        emit(PetError(e.toString()));
      }
    });
  }
} 