import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico_admin_app/controllers/auth_controller.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyA4HbT726Ehmb-n0pfLOZXLM67LFnGlgV8",
        appId: "1:315583696265:android:c36e4b17c6ae3637902558",
        messagingSenderId: "315583696265",
        projectId: "pherico-4a1e4",
        storageBucket: "pherico-4a1e4.appspot.com",
      ),
    ).then((value) {
      Get.put(AuthController());
    });
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
