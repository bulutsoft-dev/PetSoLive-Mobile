import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/pet_list_item.dart';
import '../../data/providers/pet_api_service.dart';

abstract class PetState {}
class PetInitial extends PetState {}
class PetLoading extends PetState {}
class PetLoaded extends PetState {
  final List<PetListItem> pets;
  final bool hasMore;
  PetLoaded({required this.pets, required this.hasMore});
}
class PetError extends PetState {
  final String error;
  PetError(this.error);
}

class PetCubit extends Cubit<PetState> {
  final PetApiService apiService;
  int _page = 1;
  bool _hasMore = true;
  List<PetListItem> _pets = [];
  int _totalCount = 0;
  String? _species;
  String? _color;
  String? _breed;
  String? _adoptedStatus;
  String? _search;
  int? _ownerId;
  final int _pageSize = 20;

  PetCubit(this.apiService) : super(PetInitial());

  Future<void> fetchPets({
    bool reset = false,
    String? species,
    String? color,
    String? breed,
    String? adoptedStatus,
    String? search,
    int? ownerId,
  }) async {
    if (reset) {
      _page = 1;
      _pets = [];
      _hasMore = true;
      _species = species;
      _color = color;
      _breed = breed;
      _adoptedStatus = adoptedStatus;
      _search = search;
      _ownerId = ownerId;
    }
    if (!_hasMore && !reset) return;
    emit(PetLoading());
    try {
      final result = await apiService.fetchPets(
        page: _page,
        pageSize: _pageSize,
        species: _species,
        color: _color,
        breed: _breed,
        adoptedStatus: _adoptedStatus,
        search: _search,
        ownerId: _ownerId,
      );
      final List<PetListItem> newPets = List<PetListItem>.from(result['pets']);
      _totalCount = result['totalCount'];
      if (reset) {
        _pets = newPets;
      } else {
        _pets.addAll(newPets);
      }
      _hasMore = _pets.length < _totalCount;
      emit(PetLoaded(pets: _pets, hasMore: _hasMore));
      _page++;
    } catch (e) {
      emit(PetError(e.toString()));
    }
  }

  void reset() {
    _page = 1;
    _pets = [];
    _hasMore = true;
    _species = null;
    _color = null;
    _breed = null;
    _adoptedStatus = null;
    _search = null;
    _ownerId = null;
  }
} 