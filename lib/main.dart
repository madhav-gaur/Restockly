import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restockly/constants.dart';
import 'package:restockly/routes/routes.dart';
import 'package:restockly/themes/app_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configLoading();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
          title: 'Restockly',
        theme: AppTheme.lightTheme(),
        debugShowCheckedModeBanner: false,
        routerConfig: route,
        builder: EasyLoading.init(),

        // home: Onboarding(),
      ),
    );
  }
}
