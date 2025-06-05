import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'content/preamble.dart';
import 'content/all_chapters.dart';
import 'chapter_model.dart';
import 'home_page.dart';
import 'text_page.dart';
import 'search_page.dart';
import 'about_page.dart';
import 'chat_page.dart';
import 'constitution_page.dart';
import 'splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Set status bar icons to dark
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Constitution of Zimbabwe',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
      routes: {
        '/constitution': (context) => ConstitutionPage(),
        '/search': (context) => const SearchPage(),
        '/about': (context) => const AboutPage(),
        '/chat': (context) => ChatPage(),
        // '/preamble': (context) => TextPage(
        //       title: 'Preamble',
        //       content: preambleText,
        //     ),
        ...generateRoutesFromChapters(allChapters),
      },
      initialRoute: '/',
    );
  }
}

// Recursive route generation for nested chapters
Map<String, WidgetBuilder> generateRoutesFromChapters(List<Chapter> chapters) {
  Map<String, WidgetBuilder> routes = {};

  void addRoutes(List<Chapter> chapters) {
    for (var chapter in chapters) {
      if (chapter.route != null && chapter.content != null) {
        routes[chapter.route!] = (context) => TextPage(
              title: chapter.title,
              content: chapter.content!,
            );
      }
      if (chapter.subChapters != null) {
        addRoutes(chapter.subChapters!);
      }
    }
  }

  addRoutes(chapters);
  return routes;
}
