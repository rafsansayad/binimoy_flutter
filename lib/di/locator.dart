import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../data/repositories/auth_repository.dart';
import '../data/datasources/auth_data_source.dart';
import '../data/services/storage_service.dart';
import '../data/network/network_config.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Register configured Dio instance
  locator.registerLazySingleton<Dio>(() => NetworkConfig.createBasicDio());
  
  // Register services (concrete implementations)
  locator.registerLazySingleton<StorageService>(() => SecureStorageService());
  locator.registerLazySingleton<AuthDataSource>(() => AuthDataSource(
    dio: locator<Dio>(),
  ));
  
  // Register repositories (depend on services)
  locator.registerLazySingleton<AuthRepository>(() => AuthRepository(
    authDataSource: locator<AuthDataSource>(),
    storage: locator<StorageService>(),
  ));
  
  // Add more dependencies here as needed
  // locator.registerLazySingleton<PaymentRepository>(() => PaymentRepository());
}