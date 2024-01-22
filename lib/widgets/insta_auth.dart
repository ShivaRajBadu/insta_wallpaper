import 'package:flutter/material.dart';

class InstaAuth extends StatefulWidget {
  const InstaAuth({super.key});

  @override
  State<InstaAuth> createState() => _InstaAuthState();
}

class _InstaAuthState extends State<InstaAuth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login with Instagram'),
      ),
      body: const Center(),
    );
  }
}
