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
import 'data/providers/user_api_service.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/user_repository.dart';
import 'presentation/blocs/user_cubit.dart';
import 'data/providers/account_api_service.dart';
import 'presentation/blocs/account_cubit.dart';
import 'data/repositories/account_repository_impl.dart';
import 'domain/repositories/account_repository.dart';
import 'data/providers/adoption_api_service.dart';
import 'data/repositories/adoption_repository_impl.dart';
import 'domain/repositories/adoption_repository.dart';
import 'presentation/blocs/adoption_cubit.dart';
import 'data/providers/comment_api_service.dart';
import 'data/repositories/comment_repository_impl.dart';
import 'domain/repositories/comment_repository.dart';
import 'presentation/blocs/comment_cubit.dart';
import 'data/providers/pet_owner_api_service.dart';
import 'data/providers/adoption_request_api_service.dart';

final sl = GetIt.instance;

void init() {
  sl.registerLazySingleton<PetApiService>(() => PetApiService());
  sl.registerLazySingleton<PetOwnerApiService>(() => PetOwnerApiService());
  sl.registerLazySingleton<PetRepository>(() => PetRepositoryImpl(sl()));
  sl.registerLazySingleton<LostPetAdApiService>(() => LostPetAdApiService());
  sl.registerLazySingleton<LostPetAdRepository>(() => LostPetAdRepositoryImpl(sl()));
  sl.registerLazySingleton<HelpRequestApiService>(() => HelpRequestApiService());
  sl.registerLazySingleton<HelpRequestRepository>(() => HelpRequestRepositoryImpl(sl()));
  sl.registerLazySingleton<UserApiService>(() => UserApiService());
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));
  sl.registerFactory(() => UserCubit(sl()));
  sl.registerLazySingleton<AccountApiService>(() => AccountApiService());
  sl.registerLazySingleton<AccountRepository>(() => AccountRepositoryImpl(sl()));
  sl.registerFactory(() => AccountCubit(sl<AccountRepository>()));

  // Adoption
  sl.registerLazySingleton<AdoptionApiService>(() => AdoptionApiService());
  sl.registerLazySingleton<AdoptionRepository>(() => AdoptionRepositoryImpl(sl()));
  sl.registerFactory(() => AdoptionCubit(sl()));
  sl.registerLazySingleton<AdoptionRequestApiService>(() => AdoptionRequestApiService());

  // Comment
  sl.registerLazySingleton<CommentApiService>(() => CommentApiService());
  sl.registerLazySingleton<CommentRepository>(() => CommentRepositoryImpl(sl()));
  sl.registerFactory(() => CommentCubit(sl()));
}