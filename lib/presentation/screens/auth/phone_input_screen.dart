import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/blocs.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/widgets.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final TextEditingController _controller = TextEditingController();

  bool get _isValid => _controller.text.length == 11 && _controller.text.startsWith('01');

  void _sendOtp(BuildContext context) {
    if (!_isValid) return;

    context.read<AuthBloc>().add(
      SubmitPhoneEvent(
        phone: _controller.text,
        context: AuthContext.onboarding,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OtpInputState) {
          context.pushNamed('otpVerification');
        } else if (state is ErrorState) {
          AppSnackBar.showError(context, state.message, title: 'Phone Verification Failed');
        }
      },
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              
              // App Logo
              Icon(
                Icons.account_balance_wallet_rounded,
                size: 56,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Binimoy',
                style: textTheme.headlineLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 32),
              
              // Instruction
              Text(
                'Enter your mobile number to continue',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // Phone Input
              PhoneNumberField(
                controller: _controller,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 8),
              
              // Helper text
              Text(
                'All communications are encrypted and your number is used only for verification.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              
              const Spacer(),
              
              // Send OTP Button
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final bool isLoading = state is OtpLoadingState;
                  return LoadingButton(
                    label: 'Send OTP',
                    isLoading: isLoading,
                    onPressed: _isValid && !isLoading ? () => _sendOtp(context) : null,
                  );
                },
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


