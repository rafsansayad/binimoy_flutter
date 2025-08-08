import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/blocs.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  bool _agreed = false;
  bool _loading = false;
  bool _submitted = false; 

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  bool get _readyToSubmit {
    return !_loading &&
        _agreed &&
        _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _usernameController.text.length >= 3 &&
        _pinController.text.length >= 4 &&
        _confirmPinController.text == _pinController.text;
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    setState(() => _submitted = true);
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || !_agreed) return;

    HapticFeedback.mediumImpact();
    setState(() => _loading = true);
    context.read<AuthBloc>().add(
      AuthEvent.createProfile(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        userName: _usernameController.text.trim(),
        pin: _pinController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final phone = context.read<AuthBloc>().currentPhone ?? '';
    
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          kycUpload: () {
            setState(() => _loading = false);
            context.pushNamed('kycScreen');
          },
          error: (msg) {
            setState(() => _loading = false);
            AppSnackBar.showError(context, msg, title: 'Registration Failed');
          },
          profileCreating: () => setState(() => _loading = true),
          orElse: () {},
        );
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Create Your Account', style: theme.textTheme.titleLarge),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                InfoCard(
                  icon: Icons.security,
                  message: 'Enter your name as it appears on your NID/passport for secure verification.',
                ),
                const SizedBox(height: 24),
                StatusPill(
                  icon: Icons.verified,
                  title: 'Phone Verified',
                  subtitle: '+88 $phone',
                  color: Colors.green,
                ),
                const SizedBox(height: 32),
                SectionCard(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: _submitted ? AutovalidateMode.always : AutovalidateMode.disabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 20),
                        AppTextField(
                          controller: _firstNameController,
                          label: 'First Name',
                          prefixIcon: Icons.person_outline,
                          validator: (v) => v == null || v.isEmpty ? 'This field is required' : null,
                        ),
                        const SizedBox(height: 10),
                        AppTextField(
                          controller: _lastNameController,
                          label: 'Last Name',
                          prefixIcon: Icons.person_outline,
                          validator: (v) => v == null || v.isEmpty ? 'This field is required' : null,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _usernameController,
                          label: 'Choose Username',
                          prefixIcon: Icons.alternate_email,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'This field is required';
                            if (v.length < 3) return 'Username must be at least 3 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Security Setup',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 20),
                        PinField(
                          controller: _pinController,
                          label: 'Set PIN',
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'PIN is required';
                            if (v.length < 4) return 'PIN must be at least 4 digits';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        PinField(
                          controller: _confirmPinController,
                          label: 'Confirm PIN',
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'PIN is required';
                            if (v.length < 4) return 'PIN must be at least 4 digits';
                            if (v != _pinController.text) return 'PINs do not match';
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        AgreementCheckbox(
                          value: _agreed,
                          onChanged: (v) => setState(() => _agreed = v ?? false),
                          agreementText: 'I agree to the Terms and Conditions and Privacy Policy. I understand that my information will be securely processed.',
                        ),
                        const SizedBox(height: 24),
                        LoadingButton(
                          label: 'Create My Account',
                          isLoading: _loading,
                          onPressed: _readyToSubmit ? _submit : null,
                          icon: Icons.account_circle,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}