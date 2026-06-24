import 'package:flutter/material.dart';
import 'package:sales_mobile_app/services/secureStorage.dart';
import 'package:sales_mobile_app/theme/app_colors.dart';

class AppLockToggle extends StatefulWidget {
  const AppLockToggle({super.key});

  @override
  State<AppLockToggle> createState() => _AppLockToggleState();
}

class _AppLockToggleState extends State<AppLockToggle> {
  final SecureStorage secureStorage = SecureStorage();
  bool enabled = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final value =
        await secureStorage.readSecureData("appLockEnabled");
    setState(() => enabled = value != "false");
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SwitchListTile(
        activeTrackColor: AppColors.primaryDark,
        secondary: const Icon(
          Icons.lock_outline,
          color: AppColors.primaryDark,
        ),  
        title:  Text("App Lock",
        style: TextStyle(
          color: AppColors.primaryDark
        ),),
        subtitle:
            const Text("Secure app using phone lock",
            style: TextStyle(
              color: AppColors.primary
            ),),
        value: enabled,
        onChanged: (value) async {
          setState(() => enabled = value);
          await secureStorage.writeSecureData(
            "appLockEnabled",
            value.toString(),
          );
        },
      ),
    );
  }
}
