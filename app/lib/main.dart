import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages.dart';
import 'config.dart';
//ios build, firebase iosを追加して手順に従う->https://qiita.com/kasa_le/items/fed9f25b92091bd162ce & https://zenn.dev/popy1017/articles/b9f3e46b5efeb79af1f7

final configrations = Configurations();
Future<void> init() async {
  //これ絶対に必要, initもしろ
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: configrations.apiKey,
          appId: configrations.appId,
          messagingSenderId: configrations.messagingSenderId,
          projectId: configrations.projectId));
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  init(); //Firebase Initialization
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // これを追
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LogInPage(),
    );
  }
}
