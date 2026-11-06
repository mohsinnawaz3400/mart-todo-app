import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'core/localization/locale_provider.dart';
import 'core/theme/theme_provider.dart';
import 'features/tasks/controllers/task_controller.dart';
import 'features/tasks/controllers/task_filter_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MobileAds.instance.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => TaskController(),),
        ChangeNotifierProvider(create: (_) => TaskFilterState(),),
      ],
      child: const SmartTodoApp(),
    ),
  );
}