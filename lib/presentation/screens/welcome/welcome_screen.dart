import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../logic/blocs/blocs.dart';
import 'package:go_router/go_router.dart';
import '../../../utils/size_config.dart';
import '../../widgets/widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is PhoneInputState) {
            context.pushNamed('phoneInput');
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // Top section with logo and welcome text
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 60,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      const Gap(24),
                      Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: () {
                            context.read<ThemeBloc>().add(ToggleThemeEvent());
                          },
                          icon: Icon(
                            Icons.brightness_6_rounded,
                            color: colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                        ),
                      ),
                      const Gap(32),
                  
                      Text(
                        'Welcome to Binimoy',
                        style: textTheme.headlineLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(12),
                      
                      Text(
                        'Send money to friends, split bills, and track your spending',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                // Bottom section with buttons
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      // Get Started Button
                      AppPrimaryButton(
                        label: 'Get Started',
                        onPressed: () => context.pushNamed('phoneInput'),
                      ),
                      
                      const Gap(16),
                      
                      // Login Button
                      AppOutlinedButton(
                        label: 'Log In',
                        onPressed: () => context.pushNamed('phoneInput'),
                      ),
                    ],
                  ),
                ),
                
                const Gap(32),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 