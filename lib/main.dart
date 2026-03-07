import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/audio_recorder_service.dart';
import 'providers/timeline_provider.dart';
import 'theme/app_theme.dart';
import 'routing/app_router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioRecorderService()),
        ChangeNotifierProvider(create: (_) => TimelineProvider()),
      ],
      child: const PrismaNoteApp(),
    ),
  );
}

class PrismaNoteApp extends StatelessWidget {
  const PrismaNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Prisma Note',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
