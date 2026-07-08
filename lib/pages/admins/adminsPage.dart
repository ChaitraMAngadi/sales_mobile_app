import 'package:flutter/material.dart';

class AdminsPage extends StatefulWidget {
  const AdminsPage({super.key});

  @override
  State<AdminsPage> createState() => _AdminsPageState();
}

class _AdminsPageState extends State<AdminsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("admins")
      ],
    );
  }
}