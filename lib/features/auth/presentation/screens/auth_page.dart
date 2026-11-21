import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/localization/generated/translations.g.dart';
import '../../../../core/env/env.dart';
import '../../../../core/network/exceptions/api_exception.dart';
import '../../../../core/network/exceptions/network_exception.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../shared/widgets/app_elevated_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../providers/auth_controller.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await ref.read(authControllerProvider.notifier).loginWithEmail(
          _usernameController.text.trim(),
          _passwordController.text,
        );

    if (!mounted) return;

    final authState = ref.read(authControllerProvider);
    if (authState.hasValue && authState.value != null) {
      TextInput.finishAutofillContext();
      NavigationService.goHome();
    } else if (authState.hasError) {
      TextInput.finishAutofillContext(shouldSave: false);
    }
  }

  Future<void> _handleGoogle() async {
    await ref.read(authControllerProvider.notifier).loginWithGoogle();
    if (!mounted) return;
    final authState = ref.read(authControllerProvider);
    if (authState.hasValue && authState.value != null) {
      NavigationService.goHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(Env.appName),
        actions: [
          if (Env.demoMode)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Chip(
                  label: Text(t.auth.demoChip),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (authState.hasError) ...[
              Text(
                _errorMessage(authState.error!),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
            Expanded(
              child: _LoginForm(
                formKey: _formKey,
                usernameController: _usernameController,
                passwordController: _passwordController,
                isLoading: isLoading,
                onLogin: _handleLogin,
                onGoogle: _handleGoogle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _errorMessage(Object error) {
    if (error is ApiException) return error.message;
    if (error is NetworkException) return error.message;
    return error.toString();
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.isLoading,
    required this.onLogin,
    required this.onGoogle,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onLogin;
  final VoidCallback onGoogle;

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: AutofillGroup(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              Text(
                t.auth.welcomeBack,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                t.auth.signInSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.55),
                    ),
              ),
              const SizedBox(height: 28),
              CustomTextField(
                controller: usernameController,
                label: t.auth.username,
                hint: t.auth.usernameHint,
                prefixIcon: const Icon(Icons.person_outline_rounded),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [
                  AutofillHints.username,
                  AutofillHints.email,
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return t.auth.usernameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: passwordController,
                label: t.auth.password,
                hint: t.auth.passwordHint,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                obscureText: true,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                onFieldSubmitted: (_) {
                  if (!isLoading) onLogin();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t.auth.passwordRequired;
                  }
                  return null;
                },
              ),
              if (Env.demoMode) ...[
                const SizedBox(height: 12),
                Text(
                  t.auth.demoHint,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: AppElevatedButton(
                  label: t.auth.login,
                  isLoading: isLoading,
                  onPressed: isLoading ? null : onLogin,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: isLoading ? null : onGoogle,
                  icon: const Icon(Icons.g_mobiledata, size: 30),
                  label: Text(t.auth.signInWithGoogle),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
