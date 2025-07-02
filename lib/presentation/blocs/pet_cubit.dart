import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/pet_dto.dart';
import '../../domain/repositories/pet_repository.dart';

abstract class PetState {}
class PetInitial extends PetState {}
class PetLoading extends PetState {}
class PetLoaded extends PetState {
  final List<PetDto> pets;
  PetLoaded(this.pets);
}
class PetDetailLoaded extends PetState {
  final PetDto? pet;
  PetDetailLoaded(this.pet);
}
class PetError extends PetState {
  final String error;
  PetError(this.error);
}

class PetCubit extends Cubit<PetState> {
  final PetRepository repository;
  PetCubit(this.repository) : super(PetInitial());

  Future<void> getAll() async {
    emit(PetLoading());
    try {
      final list = await repository.getAll();
      emit(PetLoaded(list));
    } catch (e) {
      emit(PetError(e.toString()));
    }
  }

  Future<void> getById(int id) async {
    emit(PetLoading());
    try {
      final pet = await repository.getById(id);
      emit(PetDetailLoaded(pet));
    } catch (e) {
      emit(PetError(e.toString()));
    }
  }

  Future<void> create(PetDto dto, String token) async {
    emit(PetLoading());
    try {
      await repository.create(dto, token);
      emit(PetInitial());
    } catch (e) {
      emit(PetError(e.toString()));
    }
  }

  Future<void> update(int id, PetDto dto, String token) async {
    emit(PetLoading());
    try {
      await repository.update(id, dto, token);
      emit(PetInitial());
    } catch (e) {
      emit(PetError(e.toString()));
    }
  }

  Future<void> delete(int id, String token) async {
    emit(PetLoading());
    try {
      await repository.delete(id, token);
      emit(PetInitial());
    } catch (e) {
      emit(PetError(e.toString()));
    }
  }
} 