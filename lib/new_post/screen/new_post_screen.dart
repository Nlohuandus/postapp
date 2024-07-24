import 'package:flutter/material.dart';
import 'package:postapp/login/widget/default_snackbar.dart';
import 'package:postapp/providers/posts_provider.dart';
import 'package:provider/provider.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  onPressedPost() async {
    FocusManager.instance.primaryFocus!.unfocus();

    try {
      if (_formKey.currentState!.validate()) {
        await context.read<PostsProvider>().newPost(
              body: bodyController.text,
              title: titleController.text,
            );

        if (!mounted) return;
        DefaultSnackbar.show(
          context,
          "El post se creo con exito!",
          Colors.green.shade300,
        );
      }
    } catch (e) {
      if (!mounted) return;
      DefaultSnackbar.show(
        context,
        "No se pudo crear el post",
        Colors.red.shade300,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Nuevo post"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                validator: (value) => (value?.isEmpty ?? true)
                    ? "El titulo no puede estar vacio"
                    : null,
                decoration: const InputDecoration(
                  hintText: "Titulo",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: bodyController,
                validator: (value) => (value?.isEmpty ?? true)
                    ? "El cuerpo no puede estar vacio"
                    : null,
                maxLines: 10,
                onEditingComplete: onPressedPost,
                decoration: const InputDecoration(
                  hintText: "Cuerpo",
                  border: OutlineInputBorder(),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Colors.deepPurple.shade300),
                      ),
                      onPressed: onPressedPost,
                      child: const Text(
                        "Crear post",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
