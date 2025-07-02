import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/lost_pet_ad_dto.dart';
import '../../domain/repositories/lost_pet_ad_repository.dart';

abstract class LostPetAdState {}
class LostPetAdInitial extends LostPetAdState {}
class LostPetAdLoading extends LostPetAdState {}
class LostPetAdLoaded extends LostPetAdState {
  final List<LostPetAdDto> ads;
  LostPetAdLoaded(this.ads);
}
class LostPetAdDetailLoaded extends LostPetAdState {
  final LostPetAdDto? ad;
  LostPetAdDetailLoaded(this.ad);
}
class LostPetAdError extends LostPetAdState {
  final String error;
  LostPetAdError(this.error);
}

class LostPetAdCubit extends Cubit<LostPetAdState> {
  final LostPetAdRepository repository;
  LostPetAdCubit(this.repository) : super(LostPetAdInitial());

  Future<void> getAll() async {
    emit(LostPetAdLoading());
    try {
      final list = await repository.getAll();
      emit(LostPetAdLoaded(list));
    } catch (e) {
      emit(LostPetAdError(e.toString()));
    }
  }

  Future<void> getById(int id) async {
    emit(LostPetAdLoading());
    try {
      final ad = await repository.getById(id);
      emit(LostPetAdDetailLoaded(ad));
    } catch (e) {
      emit(LostPetAdError(e.toString()));
    }
  }

  Future<void> create(LostPetAdDto dto, String token) async {
    emit(LostPetAdLoading());
    try {
      await repository.create(dto, token);
      emit(LostPetAdInitial());
    } catch (e) {
      emit(LostPetAdError(e.toString()));
    }
  }

  Future<void> update(int id, LostPetAdDto dto, String token) async {
    emit(LostPetAdLoading());
    try {
      await repository.update(id, dto, token);
      emit(LostPetAdInitial());
    } catch (e) {
      emit(LostPetAdError(e.toString()));
    }
  }

  Future<void> delete(int id, String token) async {
    emit(LostPetAdLoading());
    try {
      await repository.delete(id, token);
      emit(LostPetAdInitial());
    } catch (e) {
      emit(LostPetAdError(e.toString()));
    }
  }
} 