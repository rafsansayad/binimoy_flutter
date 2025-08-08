import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_event.freezed.dart';

@freezed
abstract class ThemeEvent with _$ThemeEvent {
  const factory ThemeEvent.toggleTheme() = ToggleThemeEvent;
  const factory ThemeEvent.setTheme({required bool isDark}) = SetThemeEvent;
  const factory ThemeEvent.loadTheme() = LoadThemeEvent;
} 