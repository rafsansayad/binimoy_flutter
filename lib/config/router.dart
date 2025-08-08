import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/screens/auth/phone_input_screen.dart';
import '../presentation/screens/auth/otp_verification_screen.dart';
import '../presentation/screens/welcome/welcome_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/auth/kyc_upload_screen.dart';

class AppRouter {
  static const String welcome = '/';
  static const String phoneInput = '/phone-input';
  static const String otpVerification = '/otp-verification';
  static const String register = '/register';
  static const String pinLogin = '/pin-login';
  static const String home = '/home';
  static const String kycScreen = '/kycScreen';

  static final GoRouter router = GoRouter(
    initialLocation: welcome,
    debugLogDiagnostics: true,
    routes: [
      // Welcome Screen
      GoRoute(
        path: welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      
      // Authentication Flow
      GoRoute(
        path: phoneInput,
        name: 'phoneInput',
        builder: (context, state) => const PhoneInputScreen(),
      ),
      
      // OTP Verification Screen
      GoRoute(
        path: otpVerification,
        name: 'otpVerification',
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      
      // Register Screen (Combined PIN + Profile setup)
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      


      // KYC Upload Screen
      GoRoute(
        path: kycScreen,
        name: 'kycScreen',
        builder: (context, state) => const KycUploadScreen(),
      ),
      
    ],
    
    // Global redirect for authentication
    redirect: (context, state) {
      // TODO: Implement authentication logic
      // Check if user is authenticated for protected routes
      final isAuthenticated = false; // TODO: Get from AuthBloc
      final isProtectedRoute = state.matchedLocation.startsWith(home);
      
      if (isProtectedRoute && !isAuthenticated) {
        return welcome;
      }
      
      return null;
    },
    
    // Error handling
    errorBuilder: (context, state) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      final textTheme = theme.textTheme;
      
      return Scaffold(
        backgroundColor: colorScheme.surface,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 64,
                  color: colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Page not found',
                  style: textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'The page you are looking for does not exist.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go(welcome),
                  child: const Text('Go Home'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

