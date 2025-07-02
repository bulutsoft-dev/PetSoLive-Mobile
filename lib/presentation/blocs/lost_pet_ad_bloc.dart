import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/lost_pet_ad.dart';
import '../../data/repositories/lost_pet_ad_repository_impl.dart';

// Events
abstract class LostPetAdEvent {}
class LoadLostPetAds extends LostPetAdEvent {}
class AddLostPetAd extends LostPetAdEvent {
  final LostPetAd ad;
  AddLostPetAd(this.ad);
}
class UpdateLostPetAd extends LostPetAdEvent {
  final int id;
  final LostPetAd ad;
  UpdateLostPetAd(this.id, this.ad);
}
class DeleteLostPetAd extends LostPetAdEvent {
  final int id;
  DeleteLostPetAd(this.id);
}

// States
abstract class LostPetAdState {}
class LostPetAdInitial extends LostPetAdState {}
class LostPetAdLoading extends LostPetAdState {}
class LostPetAdLoaded extends LostPetAdState {
  final List<LostPetAd> ads;
  LostPetAdLoaded(this.ads);
}
class LostPetAdError extends LostPetAdState {
  final String message;
  LostPetAdError(this.message);
}

// Bloc
class LostPetAdBloc extends Bloc<LostPetAdEvent, LostPetAdState> {
  final LostPetAdRepositoryImpl repository;
  LostPetAdBloc(this.repository) : super(LostPetAdInitial()) {
    on<LoadLostPetAds>((event, emit) async {
      emit(LostPetAdLoading());
      try {
        final ads = await repository.getAll();
        emit(LostPetAdLoaded(ads));
      } catch (e) {
        emit(LostPetAdError(e.toString()));
      }
    });
    on<AddLostPetAd>((event, emit) async {
      try {
        await repository.create(event.ad);
        add(LoadLostPetAds());
      } catch (e) {
        emit(LostPetAdError(e.toString()));
      }
    });
    on<UpdateLostPetAd>((event, emit) async {
      try {
        await repository.update(event.id, event.ad);
        add(LoadLostPetAds());
      } catch (e) {
        emit(LostPetAdError(e.toString()));
      }
    });
    on<DeleteLostPetAd>((event, emit) async {
      try {
        await repository.delete(event.id);
        add(LoadLostPetAds());
      } catch (e) {
        emit(LostPetAdError(e.toString()));
      }
    });
  }
} 