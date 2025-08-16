import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:practice/l10n/l10n.dart';
import 'package:practice/provider/language_provider.dart';
import 'package:practice/splash_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyC9vNtlXPFuFqUK3QuU3aBya1nfjhiZS-Q",
          authDomain: "doctor-app-4fe38.firebaseapp.com",
          databaseURL: "https://doctor-app-4fe38-default-rtdb.firebaseio.com",
          projectId: "doctor-app-4fe38",
          storageBucket: "doctor-app-4fe38.firebasestorage.app",
          messagingSenderId: "829673078847",
          appId: "1:829673078847:web:fb6057e6f8cd7ae8e7f88a",
          measurementId: "G-98FXZP7J8P"),
    );
  } else {
    await Firebase
        .initializeApp(); // Android, iOS dùng file google-services.json / GoogleService-Info.plist
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      supportedLocales: L10n.all,
      locale: languageProvider.locale, 
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }

}
