import 'package:flutter/material.dart';
import 'package:isango_app/core/constants/app_routes.dart';
import 'package:isango_app/core/theme/app_colors.dart';
import 'package:isango_app/core/theme/app_radii.dart';
import 'package:isango_app/core/theme/app_spacing.dart';
import 'package:isango_app/core/theme/app_text_styles.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String? _submitError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Clear any previous error
    setState(() => _submitError = null);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simulate async account creation operation
      // In a real implementation, this would call Firebase or another auth service
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      // For now, show a success message and navigate to verify email
      // In production, this would navigate to an actual email verification flow
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully!'),
          backgroundColor: AppColors.logisticsNavy,
        ),
      );

      // Navigate to home (placeholder for verify email flow)
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _submitError = 'Failed to create account. Please try again.';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.page),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.cardWhite,
                      borderRadius: BorderRadius.circular(AppRadii.card),
                      border: Border.all(color: AppColors.softBorder),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Back button
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () => Navigator.pop(context),
                                tooltip: 'Back',
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            // Header
                            const _AuthHeader(
                              icon: Icons.person_add_alt_1_outlined,
                              title: 'Create account',
                              message:
                                  'Join Isango to discover and share your community events.',
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            // Full name field
                            TextFormField(
                              controller: _nameController,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              enabled: !_isLoading,
                              decoration: const InputDecoration(
                                labelText: 'Full name',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: _validateName,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            // Email field
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              enabled: !_isLoading,
                              decoration: const InputDecoration(
                                labelText: 'Email address',
                                prefixIcon: Icon(Icons.mail_outline),
                              ),
                              validator: _validateEmail,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            // Password field
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.next,
                              enabled: !_isLoading,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  tooltip: _obscurePassword
                                      ? 'Show password'
                                      : 'Hide password',
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                              ),
                              validator: _validatePassword,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            // Confirm password field
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              textInputAction: TextInputAction.done,
                              enabled: !_isLoading,
                              onFieldSubmitted: (_) =>
                                  _isLoading ? null : _submit(),
                              decoration: InputDecoration(
                                labelText: 'Confirm password',
                                prefixIcon: const Icon(
                                  Icons.lock_reset_outlined,
                                ),
                                suffixIcon: IconButton(
                                  tooltip: _obscureConfirmPassword
                                      ? 'Show password'
                                      : 'Hide password',
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                              ),
                              validator: _validateConfirmPassword,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            // Email verification note
                            Text(
                              'We\'ll send you a verification email after account creation.',
                              style: AppTextStyles.bodyMuted,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            // Error message
                            if (_submitError != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.md,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFEBEE),
                                    borderRadius: BorderRadius.circular(
                                      AppRadii.input,
                                    ),
                                    border: Border.all(
                                      color: AppColors.criticalRed,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        color: AppColors.criticalRed,
                                        size: 20,
                                      ),
                                      const SizedBox(width: AppSpacing.md),
                                      Expanded(
                                        child: Text(
                                          _submitError!,
                                          style: AppTextStyles.body.copyWith(
                                            color: AppColors.criticalRed,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            // Create account button
                            FilledButton(
                              onPressed: _isLoading ? null : _submit,
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              AppColors.cardWhite,
                                            ),
                                      ),
                                    )
                                  : const Text('Sign up'),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            // Sign in link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account?',
                                  style: AppTextStyles.bodyMuted,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      AppRoutes.login,
                                    );
                                  },
                                  child: const Text('Log in'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Loading overlay for better UX
            if (_isLoading)
              ModalBarrier(
                color: Colors.black.withOpacity(0.1),
                dismissible: false,
              ),
          ],
        ),
      ),
    );
  }

  String? _validateName(String? value) {
    if ((value?.trim() ?? '').isEmpty) {
      return 'Enter your full name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Enter your email address';
    }
    if (!email.contains('@') || !email.contains('.')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if ((value ?? '').isEmpty) {
      return 'Create a password';
    }
    if ((value ?? '').length < 6) {
      return 'Use at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if ((value ?? '').isEmpty) {
      return 'Confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}

class _AuthHeader extends StatelessWidget {
  const _AuthHeader({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.paleSignalBlue,
            borderRadius: BorderRadius.circular(AppRadii.input),
          ),
          child: Icon(icon, color: AppColors.logisticsNavy),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(title, style: AppTextStyles.display),
        const SizedBox(height: AppSpacing.xs),
        Text(message, style: AppTextStyles.bodyMuted),
      ],
    );
  }
}
