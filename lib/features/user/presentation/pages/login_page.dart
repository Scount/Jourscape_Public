import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jourscape/features/user/presentation/providers/user_auth_notifier.dart';
import 'package:jourscape/features/user/presentation/widgets/password_text_field.dart';
import 'package:jourscape/features/user/presentation/widgets/username_text_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              UsernameTextField(textEditingController: usernameController),
              const SizedBox(height: 8),
              PasswordTextField(textEditingController: passwordController),
              const SizedBox(height: 8),
              const ElevatedButton(
                onPressed: null,
                // onPressed: () async {
                //   await ref
                //       .read(authNotifierProvider.notifier)
                //       .loginUser(
                //         usernameController.text,
                //         passwordController.text,
                //       );
                //   var result = ref.read(authNotifierProvider);
                //   result.map(
                //     data: (data) {
                //       context.go('/app');
                //     },
                //     error: (error) {},
                //     loading: (loading) {},
                //   );
                // },
                child: const Text('Login'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  await ref
                      .read(authNotifierProvider.notifier)
                      .loginAnonymously();
                  var result = ref.read(authNotifierProvider);
                  result.map(
                    data: (data) {
                      context.go('/app');
                    },
                    error: (error) {},
                    loading: (loading) {},
                  );
                },
                child: const Text('Anonym login'),
              ),
              const SizedBox(height: 8),

              // TODO(Thorben): Implement stay logged in functionality
              // Checkbox(value: true, onChanged: (bool? value) {}),
            ],
          ),
        ),
      ),
    );
  }
}
