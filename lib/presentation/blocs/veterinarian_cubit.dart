import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/veterinarian_dto.dart';
import '../../domain/repositories/veterinarian_repository.dart';

abstract class VeterinarianState {}
class VeterinarianInitial extends VeterinarianState {}
class VeterinarianLoading extends VeterinarianState {}
class VeterinarianLoaded extends VeterinarianState {
  final List<VeterinarianDto> veterinarians;
  VeterinarianLoaded(this.veterinarians);
}
class VeterinarianError extends VeterinarianState {
  final String error;
  VeterinarianError(this.error);
}

class VeterinarianCubit extends Cubit<VeterinarianState> {
  final VeterinarianRepository repository;
  VeterinarianCubit(this.repository) : super(VeterinarianInitial());

  Future<void> getAll() async {
    emit(VeterinarianLoading());
    try {
      final list = await repository.getAll();
      emit(VeterinarianLoaded(list));
    } catch (e) {
      emit(VeterinarianError(e.toString()));
    }
  }

  Future<void> register(VeterinarianDto dto, String token) async {
    emit(VeterinarianLoading());
    try {
      await repository.register(dto, token);
      emit(VeterinarianInitial());
    } catch (e) {
      emit(VeterinarianError(e.toString()));
    }
  }

  Future<void> approve(int id, String token) async {
    emit(VeterinarianLoading());
    try {
      await repository.approve(id, token);
      emit(VeterinarianInitial());
    } catch (e) {
      emit(VeterinarianError(e.toString()));
    }
  }

  Future<void> reject(int id, String token) async {
    emit(VeterinarianLoading());
    try {
      await repository.reject(id, token);
      emit(VeterinarianInitial());
    } catch (e) {
      emit(VeterinarianError(e.toString()));
    }
  }
} 