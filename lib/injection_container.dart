import 'package:get_it/get_it.dart';
import 'data/repositories/pet_repository_impl.dart';
import 'domain/repositories/pet_repository.dart';
import 'data/providers/pet_api_service.dart';

final sl = GetIt.instance;

void init() {
  sl.registerLazySingleton<PetApiService>(() => PetApiService());
  sl.registerLazySingleton<PetRepository>(() => PetRepositoryImpl(sl()));
  // ... diğer bağımlılıklar ...
} 