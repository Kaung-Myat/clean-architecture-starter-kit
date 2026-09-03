import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/env/env.dart';
import '../../../../core/network/exceptions/api_exception.dart';
import '../../../../core/network/exceptions/network_exception.dart';
import '../providers/auth_controller.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final authNotifier = ref.read(authControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(Env.appName),
        actions: [
          if (Env.demoMode)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Center(
                child: Chip(
                  label: Text('DEMO'),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: authState.when(
            data: (user) {
              if (user == null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: authNotifier.loginWithGoogle,
                      icon: const Icon(Icons.g_mobiledata, size: 30),
                      label: const Text('Sign in with Google'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => authNotifier.loginWithEmail(
                        'dev@test.com',
                        '123456',
                      ),
                      icon: const Icon(Icons.email),
                      label: const Text('Sign in (demo password)'),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => authNotifier.loginWithEmail(
                        'dev@test.com',
                        'wrong_pass',
                      ),
                      icon: const Icon(Icons.error_outline, color: Colors.red),
                      label: const Text('Test wrong password'),
                    ),
                  ],
                );
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome, ${user.name}!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Email: ${user.email}'),
                  Text('Auth: ${user.authType}'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => authNotifier.updateName(user.name),
                    child: const Text('Update with SAME name'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => authNotifier.updateName('Kaung'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Update with NEW name'),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: authNotifier.logout,
                    child: const Text('Log out'),
                  ),
                ],
              );
            },
            error: (error, _) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _errorMessage(error),
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: authNotifier.logout,
                  child: const Text('Try again'),
                ),
              ],
            ),
            loading: () => const CircularProgressIndicator(),
          ),
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
