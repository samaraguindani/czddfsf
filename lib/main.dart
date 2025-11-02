import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/supabase_config.dart';
import 'providers/auth_provider.dart';
import 'providers/service_provider.dart';
import 'providers/request_provider.dart';
import 'pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Supabase
  await SupabaseConfig.initialize();
  
  runApp(const UNIFAZApp());
}

class UNIFAZApp extends StatelessWidget {
  const UNIFAZApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
        ChangeNotifierProvider(create: (_) => RequestProvider()),
      ],
      child: MaterialApp(
        title: 'UNIFAZ',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF87a492),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF87a492),
            secondary: const Color(0xFFc9a56f),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'Garet',
          textTheme: const TextTheme(
            // Títulos - Gliker
            titleLarge: TextStyle(
              fontFamily: 'Gliker',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            headlineLarge: TextStyle(
              fontFamily: 'Gliker',
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            headlineMedium: TextStyle(
              fontFamily: 'Gliker',
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            headlineSmall: TextStyle(
              fontFamily: 'Gliker',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            titleMedium: TextStyle(
              fontFamily: 'Gliker',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            titleSmall: TextStyle(
              fontFamily: 'Gliker',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            // Textos normais - Garet Book
            bodyLarge: TextStyle(
              fontFamily: 'Garet',
              fontSize: 16,
            ),
            bodyMedium: TextStyle(
              fontFamily: 'Garet',
              fontSize: 14,
            ),
            bodySmall: TextStyle(
              fontFamily: 'Garet',
              fontSize: 12,
            ),
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Color(0xFF87a492),
            foregroundColor: Colors.white,
            titleTextStyle: TextStyle(
              fontFamily: 'Gliker',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF87a492),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF87a492),
            foregroundColor: Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF87a492), width: 2),
            ),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Color(0xFF87a492),
            unselectedItemColor: Colors.grey,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
