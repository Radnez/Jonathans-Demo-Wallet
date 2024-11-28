import 'package:demo_wallet/src/config/routes/routes.dart';
import 'package:demo_wallet/src/config/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'src/config/themes/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  //Uncomment this if you want to try use on android
  // await requestPermissions();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}
//Uncomment below this if you want to try use on android

// Future<void> requestPermissions() async {
//   // Request camera permission
//   final cameraStatus = await Permission.camera.request();
//
//   // Request microphone permission
//   final microphoneStatus = await Permission.microphone.request();
//
//   // Handle denied or permanently denied permissions
//   if (cameraStatus.isDenied || microphoneStatus.isDenied) {
//     print("Permissions are denied. The app may not function correctly.");
//     // Optionally, show a dialog or notify the user about the consequences.
//   } else if (cameraStatus.isPermanentlyDenied ||
//       microphoneStatus.isPermanentlyDenied) {
//     print("Permissions are permanently denied. Redirecting to settings...");
//     // Redirect the user to app settings if permissions are permanently denied
//     await openAppSettings();
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: Routes.paymentMethod,
          onGenerateRoute: Routes.generateRoute,
        );
      },
    );
  }
}
