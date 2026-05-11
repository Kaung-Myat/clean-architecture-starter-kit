import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth_controller.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("🔄 AuthPage Rebuild ဖြစ်သွားပါပြီ!");
    // String.fromEnvironment ဖြင့် .env ထဲက တန်ဖိုးကို လှမ်းယူခြင်း
    // (Local မှာ Run တဲ့အခါ မရှိရင် 'Default App' ဟု ပေါ်နေမည်)
    const appName = String.fromEnvironment('APP_NAME', defaultValue: 'Default App');
    final authState = ref.watch(authControllerProvider);
    final authNotifier = ref.read(authControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text(appName)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: authState.when(
            data: (user) {
              if (user == null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(onPressed: () => authNotifier.loginWithGoogle(), icon: const Icon(Icons.g_mobiledata, size: 30), label: const Text('Sign in with Google')),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(onPressed: () => authNotifier.loginWithEmail("dev@test.com", "123456"), icon: const Icon(Icons.email), label: const Text('Traditional Sign in (Correct)')),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => authNotifier.loginWithEmail("dev@test.com", "wrong_pass"),
                      icon: const Icon(Icons.error, color: Colors.red),
                      label: const Text('Test Wrong Password'),
                    ),
                  ],
                );
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Hello"),
                  Text('Welcome, ${user.name}!', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('Email: ${user.email}'),
                  const SizedBox(height: 30),

                  // ၁။ နာမည် အတူတူပဲကို ထပ်ပြင်ကြည့်မည့် ခလုတ် (Equatable ကြောင့် Rebuild မဖြစ်ရပါ)
                  ElevatedButton(onPressed: () => authNotifier.updateName(user.name), child: const Text('Update with SAME Name')),
                  const SizedBox(height: 10),

                  // ၂။ နာမည် အသစ်ပြောင်းမည့် ခလုတ် (Rebuild ဖြစ်ရပါမည်)
                  ElevatedButton(
                    onPressed: () => authNotifier.updateName("Kaung"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Update with NEW Name'),
                  ),
                  const SizedBox(height: 30),

                  ElevatedButton(onPressed: authNotifier.logout, child: const Text('Log out')),
                ],
              );
            },
            error: (error, stack) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $error', style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 10),
                ElevatedButton(onPressed: authNotifier.logout, child: const Text('Try Again')),
              ],
            ),
            loading: () => const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
