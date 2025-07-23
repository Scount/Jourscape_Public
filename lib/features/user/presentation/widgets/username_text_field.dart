import 'package:flutter/material.dart';

class UsernameTextField extends StatelessWidget {
  const UsernameTextField({required this.textEditingController, super.key});
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: false,
      controller: textEditingController,
      decoration: const InputDecoration(
        hintText: 'Username',
        hintStyle: TextStyle(color: Colors.black12),

        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: const BorderSide(color: Colors.black38, width: 1.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        prefixIcon: Icon(Icons.person),
      ),
    );
  }
}
