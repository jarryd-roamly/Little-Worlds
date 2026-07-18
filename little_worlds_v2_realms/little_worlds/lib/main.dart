import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/app_state.dart';
import 'core/strings.dart';
import 'scenes/hub_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Kids apps: landscape, fullscreen, no accidental system UI.
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  final state = await AppState.load();
  runApp(LittleWorldsApp(state: state));
}

class LittleWorldsApp extends StatelessWidget {
  final AppState state;
  const LittleWorldsApp({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      state: state,
      child: MaterialApp(
        title: 'Little Worlds',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFB74D)),
          fontFamily: 'Rounded', // swap in a licensed rounded font later
        ),
        home: const HubScreen(),
      ),
    );
  }
}

/// Simple InheritedWidget so any screen can reach app state without packages.
class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({super.key, required AppState state, required super.child})
      : super(notifier: state);
  static AppState of(BuildContext c) =>
      c.dependOnInheritedWidgetOfExactType<AppStateScope>()!.notifier!;
}
