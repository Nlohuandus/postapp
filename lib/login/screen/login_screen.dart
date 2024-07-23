import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:postapp/login/provider/login_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late final LoginProvider loginProvider;
  final List<TextInputFormatter> inputFormatters = [
    FilteringTextInputFormatter.deny(" "),
  ];

  @override
  void initState() {
    super.initState();
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
  }

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  onTapLogin() {
    String? result = loginProvider.doAuthentication(
      user: userController.text,
      password: passwordController.text,
    );

    if (loginProvider.isAuthenticated && result == null) {
      context.pushReplacementNamed("home");
    }
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loginProvider.error!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Icon get togglePasswordIcon {
    return Icon(
      context.watch<LoginProvider>().showPassword
          ? Icons.visibility_off
          : Icons.visibility,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Form(
          key: loginProvider.formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: userController,
                inputFormatters: inputFormatters,
                decoration: const InputDecoration(
                  hintText: "Usuario",
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(
                    fontSize: 0,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                onEditingComplete: onTapLogin,
                controller: passwordController,
                inputFormatters: inputFormatters,
                obscureText: !loginProvider.showPassword,
                decoration: InputDecoration(
                  suffixIconColor: Colors.grey,
                  suffixIcon: GestureDetector(
                    onTap: loginProvider.toggleShowPassword,
                    child: togglePasswordIcon,
                  ),
                  hintText: "Contraseña",
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Colors.deepPurple.shade300),
                ),
                onPressed: onTapLogin,
                child: const Text(
                  "Iniciar sesion",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
