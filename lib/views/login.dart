import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:obs_scorer_client/main.dart';
import 'package:obs_scorer_client/src/settings.dart';
import 'package:obs_scorer_client/views/home.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final addressController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 640,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Login", style: Theme.of(context).textTheme.headline6),
                  const SizedBox(height: 16),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Address and port",
                      hintText: "127.0.0.1:4455"
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password (optional)",
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          final value = ref.read(settingsProvider);
                          value.connection.address = addressController.text;
                          value.connection.password = passwordController.text;
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeView()));
                        },
                        child: const Text("Login"),
                      ),
                      const SizedBox(width: 16),
                      // OutlinedButton(onPressed: () {}, child: const Text("Scan QR Code")),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}