import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/doctor_home_page.dart';
import 'pages/login_page.dart';
import 'models/user_model.dart';
import 'services/auth_service.dart';
import 'store/healix_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/providers/auth_provider.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final user = await authService.restoreSession();
  Widget initialPage = const LoginPage();
  
  if (user != null) {
    healixStore.setUserName(user.fullName);
    if (user.role == 'doctor') {
      initialPage = DoctorHomePage(username: user.fullName);
    } else {
      initialPage = HomePage(username: user.fullName);
    }
  }

  runApp(
    ProviderScope(
      child: HealixApp(initialPage: initialPage, initialUser: user),
    ),
  );
}

class HealixApp extends ConsumerStatefulWidget {
  final Widget initialPage;
  final UserModel? initialUser;
  const HealixApp({super.key, required this.initialPage, this.initialUser});

  @override
  ConsumerState<HealixApp> createState() => _HealixAppState();
}

class _HealixAppState extends ConsumerState<HealixApp> {
  @override
  void initState() {
    super.initState();
    // Restore session in the provider on start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialUser != null) {
        ref.read(authStateProvider.notifier).restoreSession(widget.initialUser);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'Healix Patient Portal',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF00AACD),
              primary: const Color(0xFF00AACD),
              surface: Colors.white,
            ),
            scaffoldBackgroundColor: const Color(0xFFF8FAFC),
            fontFamily: 'Inter',
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              brightness: Brightness.dark,
              seedColor: const Color(0xFF00AACD),
              primary: const Color(0xFF00AACD),
              surface: const Color(0xFF1E293B),
              background: const Color(0xFF0F172A),
            ),
            scaffoldBackgroundColor: const Color(0xFF0F172A),
            fontFamily: 'Inter',
          ),
          home: widget.initialPage,
        );
      },
    );
  }
}
