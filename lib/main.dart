import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/router.dart';
import 'data/repositories/auth_repository.dart';
import 'data/services/storage_service.dart';
import 'logic/blocs/auth/auth_bloc.dart';
import 'logic/blocs/theme/theme_bloc.dart';
import 'logic/blocs/theme/theme_event.dart';
import 'logic/blocs/theme/theme_state.dart';
import 'di/locator.dart';

void main() {
  setupLocator(); // Initialize dependency injection
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            repository: locator<AuthRepository>(),
          ),
        ),
        BlocProvider<ThemeBloc>(
          create: (context) {
            final themeBloc = ThemeBloc(
              storageService: locator<StorageService>(),
            );
            // Load saved theme on startup
            themeBloc.add(LoadThemeEvent());
            return themeBloc;
          },
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Binimoy',
            debugShowCheckedModeBanner: false,
            theme: state.themeData,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
