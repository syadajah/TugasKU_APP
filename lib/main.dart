import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tugasku/screen/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: "https://hfhiqtwputdtfjgkwtxk.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhmaGlxdHdwdXRkdGZqZ2t3dHhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE1NzE4MDUsImV4cCI6MjA1NzE0NzgwNX0.oiFCSqClZFluCtzJzEuYQuRfd8PIT985Wjf8W53Ba4k");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TugasKU APP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xfff7f7f7)),
        useMaterial3: true,
      ),
      home: Splash(),
    );
  }
}
