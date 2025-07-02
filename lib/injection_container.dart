import 'package:get_it/get_it.dart';
import 'data/repositories/pet_repository_impl.dart';
import 'domain/repositories/pet_repository.dart';
import 'data/providers/pet_api_service.dart';
import 'data/repositories/lost_pet_ad_repository_impl.dart';
import 'domain/repositories/lost_pet_ad_repository.dart';
import 'data/providers/lost_pet_ad_api_service.dart';
import 'data/repositories/help_request_repository_impl.dart';
import 'domain/repositories/help_request_repository.dart';
import 'data/providers/help_request_api_service.dart';

final sl = GetIt.instance;

void init() {
  sl.registerLazySingleton<PetApiService>(() => PetApiService());
  sl.registerLazySingleton<PetRepository>(() => PetRepositoryImpl(sl()));
  sl.registerLazySingleton<LostPetAdApiService>(() => LostPetAdApiService());
  sl.registerLazySingleton<LostPetAdRepository>(() => LostPetAdRepositoryImpl(sl()));
  sl.registerLazySingleton<HelpRequestApiService>(() => HelpRequestApiService());
  sl.registerLazySingleton<HelpRequestRepository>(() => HelpRequestRepositoryImpl(sl()));
}