import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/theme_config.dart';
import '../../../data/services/storage_service.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final StorageService _storageService;

  ThemeBloc({required StorageService storageService})
      : _storageService = storageService,
        super(ThemeState(
          isDarkMode: false,
          themeData: ThemeConfig.lightTheme,
        )) {
    
    on<LoadThemeEvent>(_onLoadTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<SetThemeEvent>(_onSetTheme);
  }

  Future<void> _onLoadTheme(LoadThemeEvent event, Emitter<ThemeState> emit) async {
    final themeString = await _storageService.getString('theme_mode') ?? 'light';
    final isDarkMode = themeString == 'dark';
    final themeData = isDarkMode ? ThemeConfig.darkTheme : ThemeConfig.lightTheme;
    
    emit(ThemeState(isDarkMode: isDarkMode, themeData: themeData));
  }

  Future<void> _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) async {
    final newIsDarkMode = !state.isDarkMode;
    final newThemeData = newIsDarkMode ? ThemeConfig.darkTheme : ThemeConfig.lightTheme;
    
    await _storageService.saveString('theme_mode', newIsDarkMode ? 'dark' : 'light');
    emit(ThemeState(isDarkMode: newIsDarkMode, themeData: newThemeData));
  }

  Future<void> _onSetTheme(SetThemeEvent event, Emitter<ThemeState> emit) async {
    final newThemeData = event.isDark ? ThemeConfig.darkTheme : ThemeConfig.lightTheme;
    
    await _storageService.saveString('theme_mode', event.isDark ? 'dark' : 'light');
    emit(ThemeState(isDarkMode: event.isDark, themeData: newThemeData));
  }
} 